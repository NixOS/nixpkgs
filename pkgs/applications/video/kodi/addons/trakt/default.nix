{ lib, buildKodiAddon, fetchzip, addonUpdateScript, trakt-module, dateutil }:
buildKodiAddon rec {
  pname = "trakt";
  namespace = "script.trakt";
  version = "3.5.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-OyU6S5r/y3vqW6Wg6OP0+Zn4YchBy8x1i++hzCQHyx0=";
  };

  propagatedBuildInputs = [
    dateutil
    trakt-module
  ];

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.trakt";
    };
  };

  meta = with lib; {
    homepage = "https://kodi.wiki/view/Add-on:Trakt";
    description = "Trakt.tv movie and TV show scrobbler for Kodi";
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
