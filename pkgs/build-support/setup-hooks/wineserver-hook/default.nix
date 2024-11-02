{ lib
, makeSetupHook
, writeScript
, wine
}:
let
  wineExecutable = lib.getExe wine;
in
makeSetupHook {
  name = "wineserver-hook";

  propagatedBuildInputs = [
    wine
  ];

  passthru = {
    inherit wine wineExecutable;
  };

} (writeScript "wineserver-hook" ''
  export WINEDEBUG=fixme-all,err-systray
  export WINEPREFIX=/tmp/wine
  export WINEDLLOVERRIDES="winemenubuilder.exe=d"

  mkdir -p "$WINEPREFIX"
  ${wine}/bin/wineserver -p >/dev/null
  ${wine}/bin/wineboot -i >/dev/null

  ${wineExecutable} reg add 'HKCU\Software\Wine\Drivers' /f /v Graphics /d "null" >/dev/null
  ${wineExecutable} reg add 'HKCU\Software\Wine\Drivers' /f /v Audio /d "" >/dev/null
  ${wineExecutable} reg add 'HKCU\Software\Wine\WineDbg' /f /v ShowCrashDialog /t REG_DWORD /d 0 >/dev/null
'')
