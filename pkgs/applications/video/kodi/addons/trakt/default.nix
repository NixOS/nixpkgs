{ lib, buildKodiAddon, fetchzip, addonUpdateScript, trakt-module, dateutil }:
buildKodiAddon rec {
  pname = "trakt";
  namespace = "script.trakt";
  version = "3.6.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-ZlBucYYRA1cL5c0H1jhXeKE1itReZe2gAJYFFxuUebo=";
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
