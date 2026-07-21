{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  dateutil,
  requests,
  xbmcswift2,
}:

buildKodiAddon rec {
  pname = "arteplussept";
  namespace = "plugin.video.arteplussept";
  version = "1.5.2";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    hash = "sha256-kYIN9I+hSWBYbaUsFRDkcU3FngQRzxmGrjN7rnsWiaA=";
  };

  propagatedBuildInputs = [
    dateutil
    requests
    xbmcswift2
  ];

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.arteplussept";
    };
  };

  meta = {
    homepage = "https://github.com/thomas-ernest/plugin.video.arteplussept";
    description = "Watch videos available on Arte+7";
    license = lib.licenses.mit;
    teams = [ lib.teams.kodi ];
  };
}
