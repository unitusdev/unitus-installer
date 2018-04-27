;NSIS Modern User Interface
; Unitus Installer for Windows 32-bit
; Written by nzsquirrell

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General


  !define VERSION "0.14.2.2"
  !define ARCH "32"

  ;Name and file
  Name "Unitus"
  OutFile "output\UnitusSetup-${VERSION}-win${ARCH}.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES32\Unitus"

  ;Get installation folder from registry if available
  InstallDirRegKey HKLM "Software\Unitus" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel highest

  ; Change icons to use Unitus's
  !define MUI_ICON "resources\unitus.ico"
  !define MUI_UNICON "resources\unitus.ico"

  ; use LZMA compression to shrink as small as possible
  SetCompressor /SOLID LZMA

  VIAddVersionKey "ProductName" "Unitus"
  VIAddVersionKey "FileVersion" "${VERSION}"
  VIAddVersionKey "FileDescription" "Unitus ${ARCH}-bit Installer"
  VIProductVersion "${VERSION}"
  VIFileVersion "${VERSION}"

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages
  !define MUI_WELCOMEPAGE_TITLE "Unitus ${VERSION} ${ARCH}-bit Installer"
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "resources\license.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Graphical Interface" SecGUI

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...

  File "resources\${VERSION}\${ARCH}-bit\unitus-qt.exe"
  File "resources\unitus.ico"

  ; add firewall exception
  SimpleFC::AddApplication Unitus-Qt "$INSTDIR\unitus-qt.exe" 0 2 "" 1

  ; shortcuts
  SetShellVarContext all
  CreateShortcut "$SMPROGRAMS\Unitus.lnk" "$INSTDIR\unitus-qt.exe"

  MessageBox MB_YESNO|MB_ICONQUESTION "Do you want to create a shortcut on the desktop?" IDYES true IDNO false
  true:
	CreateShortcut "$DESKTOP\Unitus.lnk" "$INSTDIR\unitus-qt.exe"
  false:

  ;Store installation folder
  WriteRegStr HKCU "Software\Unitus" "" $INSTDIR

  Call Uninstaller

SectionEnd

Section "Daemon & Command Line" SecCMD

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...

  File "resources\${VERSION}\${ARCH}-bit\unitusd.exe"
  File "resources\${VERSION}\${ARCH}-bit\unitus-cli.exe"
  File "resources\${VERSION}\${ARCH}-bit\unitus-tx.exe"
  File "resources\unitus.ico"

  ; add firewall exception
  SimpleFC::AddApplication Unitus-Daemon "$INSTDIR\unitusd.exe" 0 2 "" 1

  ;Store installation folder
  WriteRegStr HKCU "Software\Unitus" "" $INSTDIR

  Call Uninstaller

SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecGUI ${LANG_ENGLISH} "Graphical Wallet."
  LangString DESC_SecCMD ${LANG_ENGLISH} "Wallet daemon and command line tool."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecGUI} $(DESC_SecGUI)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecCMD} $(DESC_SecCMD)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;ADD YOUR OWN FILES HERE...

  ; remove firewall exceptions

  SimpleFC::RemoveApplication "$INSTDIR\unitus-qt.exe"
  SimpleFC::RemoveApplication "$INSTDIR\unitusd.exe"

  Delete "$INSTDIR\unitus-qt.exe"
  Delete "$INSTDIR\unitusd.exe"
  Delete "$INSTDIR\unitus-cli.exe"
  Delete "$INSTDIR\unitus-tx.exe"
  SetShellVarContext all
  Delete "$SMPROGRAMS\Unitus.lnk"
  Delete "$DESKTOP\Unitus.lnk"

  Delete "$INSTDIR\Uninstall.exe"

  RMDir "$INSTDIR"

  DeleteRegKey /ifempty HKCU "Software\Unitus"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Unitus"

SectionEnd

Function Uninstaller

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ;Add uninstaller to Add/Remove Programs
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Unitus" "DisplayName" "Unitus"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Unitus" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Unitus" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Unitus" "DisplayIcon" "$INSTDIR\unitus.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Unitus" "DisplayVersion" "${VERSION}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Unitus" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Unitus" "NoRepair" 1

FunctionEnd