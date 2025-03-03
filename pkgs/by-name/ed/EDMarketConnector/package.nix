{
  lib,
  fetchFromGitHub,
  python3Full,
  writeShellScriptBin,
}:
let
  pkgVersion = "5.12.2";
  pythonEnv = python3Full.buildEnv.override {
    extraLibs = with python3Full.pkgs.pythonPackages; [
      requests
      pillow
      watchdog
      semantic-version
      psutil
    ];
    ignoreCollisions = true;
  };

  src = fetchFromGitHub {
    owner = "EDCD";
    repo = "EDMarketConnector";
    tag = "Release/${pkgVersion}";
    hash = "sha256-3ywu/EJdIsKqTN3uaA5F0tZK6tybl483Yiwqh7W4yCc=";
  };
in
writeShellScriptBin "EDMarketConnector" ''
  exec ${pythonEnv}/bin/python ${src}/EDMarketConnector.py "$@"
''
// {
  pname = "EDMarketConnector";
  version = "${pkgVersion}";
  meta = {
    homepage = "https://github.com/EDCD/EDMarketConnector";
    description = "Uploads Elite: Dangerous market data to popular trading tools";
    longDescription = "Downloads commodity market and other station data from the game Elite: Dangerous for use with all popular online and offline trading tools. ";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.x86_64;
    mainProgram = "EDMarketConnector";
    maintainers = with lib.maintainers; [ jiriks74 ];
  };
}
