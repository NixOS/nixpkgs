{ lib, buildKodiAddon, fetchzip, addonUpdateScript, dateutil, requests, xbmcswift2 }:

buildKodiAddon rec {
  pname = "arteplussept";
  namespace = "plugin.video.arteplussept";
  version = "1.1.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    hash = "sha256-IYodi0Uz16Qg4MHCz/K06pEXblrsBxHD25fb6LrW8To=";
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
    homepage = "https://github.com/known-as-bmf/plugin.video.arteplussept";
    description = "Watch videos available on Arte+7";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
