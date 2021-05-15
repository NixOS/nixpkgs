{ lib, buildKodiAddon, fetchzip, addonUpdateScript, six, requests, inputstreamhelper }:

buildKodiAddon rec {
  pname = "youtube";
  namespace = "plugin.video.youtube";
  version = "6.8.10+matrix.1";

  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/matrix/${namespace}/${namespace}-${version}.zip";
    sha256 = "18z9zh6yqihnmfwd6cc4kpy2frzbarvhg8qpyc3w851ad053q7v0";
  };

  propagatedBuildInputs = [
    six
    requests
    inputstreamhelper
  ];

  passthru.updateScript = addonUpdateScript {
    attrPath = "kodi.packages.youtube";
  };

  meta = with lib; {
    homepage = "https://github.com/anxdpanic/plugin.video.youtube";
    description = "YouTube is one of the biggest video-sharing websites of the world";
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
