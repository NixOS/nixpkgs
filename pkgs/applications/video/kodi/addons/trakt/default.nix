{ lib, buildKodiAddon, fetchzip, addonUpdateScript, trakt-module, dateutil }:
buildKodiAddon rec {
  pname = "trakt";
  namespace = "script.trakt";
  version = "3.5.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "07fb0wjcr8ggidswrjs1r1hzi6grykiyi855bgm7pjzzk95kl99v";
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
