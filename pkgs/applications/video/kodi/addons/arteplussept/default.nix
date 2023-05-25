{ lib, buildKodiAddon, fetchzip, addonUpdateScript, dateutil, requests, xbmcswift2 }:

buildKodiAddon rec {
  pname = "arteplussept";
  namespace = "plugin.video.arteplussept";
  version = "1.1.9";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    hash = "sha256-B4IIYwWrQ5U+aPl9nzAN3HWaQjHX1G+hxpicBgBAwiA=";
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
    maintainers = teams.kodi.members;
  };
}
