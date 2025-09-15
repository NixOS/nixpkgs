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
  version = "1.4.3";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    hash = "sha256-05k0ijTp0JDtHdxTJ5I8ff47F6LXGP78rInyX0nD7W8=";
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

  meta = with lib; {
    homepage = "https://github.com/thomas-ernest/plugin.video.arteplussept";
    description = "Watch videos available on Arte+7";
    license = licenses.mit;
    teams = [ teams.kodi ];
  };
}
