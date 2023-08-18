{ lib, buildKodiAddon, fetchzip, addonUpdateScript, dateutil, requests, xbmcswift2 }:

buildKodiAddon rec {
  pname = "arteplussept";
  namespace = "plugin.video.arteplussept";
  version = "1.4.0";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/${namespace}/${namespace}-${version}.zip";
    hash = "sha256-m7DHQVg0pcLGCHTdecCTGfanUWhuPMHdllbg+47hxEI=";
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
