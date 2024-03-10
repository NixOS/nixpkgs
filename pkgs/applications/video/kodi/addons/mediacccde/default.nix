{ lib, buildKodiAddon, fetchzip, addonUpdateScript, requests, routing }:

buildKodiAddon rec {
  pname = "media.ccc.de";
  namespace = "plugin.video.media-ccc-de";
  version = "0.3.0+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/nexus/plugin.video.media-ccc-de/plugin.video.media-ccc-de-${version}.zip";
    hash = "sha256-T8J2HtPVDfaPU0gZEa0xVBzwjNInxkRFCCSxS53QhmU=";
  };

  propagatedBuildInputs = [
    requests
    routing
  ];

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.mediacccde";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/voc/plugin.video.media-ccc-de/";
    description = "media.ccc.de for Kodi";
    license = licenses.mit;
    maintainers = teams.kodi.members;
  };
}
