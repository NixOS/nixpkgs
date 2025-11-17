{
  buildKodiAddon,
  fetchFromGitHub,
  lib,
}:
buildKodiAddon rec {
  pname = "bluetooth-manager";
  namespace = "script.bluetooth.man";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "wastis";
    repo = "BluetoothManager";
    tag = "v${version}";
    hash = "sha256-KKaR7rIkflMYU6EDBEcorHQ3t7jsB4Qe6Ikg+eBblkA=";
  };

  meta = with lib; {
    description = "Addon that allows to manage bluetooth devices from within a Linux based Kodi";
    platforms = platforms.all;
    maintainers = teams.kodi.members;
    license = licenses.gpl3Plus;
  };
}
