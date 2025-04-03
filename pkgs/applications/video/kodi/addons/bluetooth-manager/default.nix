{
  kodiPackages,
  fetchFromGitHub,
  pulseaudioFull,
  lib,
}:
kodiPackages.buildKodiAddon {
  pname = "bluetooth-manager";
  namespace = "script.bluetooth.man";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "wastis";
    repo = "BluetoothManager";
    rev = "1fc1d8ee764e3440e50317eb966e2e005fcd6873";
    hash = "sha256-mwiWpFa8RcbAljEuckeEFuQTe/yM+HFjNXJUlsIZuCc=";
  };

  passthru = {
    pythonPath = "resources/site-packages";
  };

  propagatedBuildInputs = [
    pulseaudioFull
  ];

  meta = with lib; {
    description = "Addon that allows to manage bluetooth devices from within a Linux based Kodi.";
    platforms = platforms.all;
    maintainers = teams.kodi.members;
  };
}
