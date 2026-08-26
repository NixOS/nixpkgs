{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  trakt-module,
  dateutil,
}:
buildKodiAddon rec {
  pname = "trakt";
  namespace = "script.trakt";
  version = "3.9.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-kjA3kk1Ii3PylfwgiKpLCRe6TGMNDgOppFJM38rgVWU=";
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

  meta = {
    homepage = "https://kodi.wiki/view/Add-on:Trakt";
    description = "Trakt.tv movie and TV show scrobbler for Kodi";
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.kodi ];
  };
}
