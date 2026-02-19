{
  buildKodiAddon,
  fetchFromGitHub,
  lib,
}:
buildKodiAddon rec {
  pname = "bluetooth-manager";
  namespace = "script.bluetooth.man";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "wastis";
    repo = "BluetoothManager";
    tag = "v${version}";
    hash = "sha256-hWNi2hm5FmkRPamxMSHF3WfQ+2V+qQzkkTJWuqazbAc=";
  };

  meta = {
    description = "Addon that allows to manage bluetooth devices from within a Linux based Kodi";
    platforms = lib.platforms.all;
    maintainers = lib.teams.kodi.members;
    license = lib.licenses.gpl3Plus;
  };
}
