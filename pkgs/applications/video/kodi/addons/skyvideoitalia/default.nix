{
  lib,
  rel,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
  requests,
  inputstreamhelper,
  simplecache,
}:

buildKodiAddon rec {
  pname = "skyvideoitalia";
  namespace = "plugin.video.skyvideoitalia";
  version = "1.0.4";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
    sha256 = "sha256-ciLtqT++6bn7la4xRVvlRwzbbUUUPN5WU35rJpR4l+w=";
  };

  propagatedBuildInputs = [
    requests
    inputstreamhelper
    simplecache
  ];

  passthru = {
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.skyvideoitalia";
    };
  };

  meta = with lib; {
    homepage = "https://www.github.com/nixxo/plugin.video.skyvideoitalia";
    description = "Show video content from the website of Sky Italia (video.sky.it). News, sport, entertainment and much more";
    license = licenses.gpl3Plus;
    teams = [ teams.kodi ];
  };
}
