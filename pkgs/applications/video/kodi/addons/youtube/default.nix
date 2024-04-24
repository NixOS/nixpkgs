{ lib, buildKodiAddon, fetchFromGitHub, six, requests, infotagger, inputstreamhelper }:

buildKodiAddon rec {
  pname = "youtube";
  namespace = "plugin.video.youtube";
  version = "7.0.5";

  src = fetchFromGitHub {
    owner = "anxdpanic";
    repo = "plugin.video.youtube";
    rev = "v${version}";
    hash = "sha256-oM1n0Rye2QagxXoAZ/6mXKeGqKjEdewgS79lhp+yCQI=";
  };

  propagatedBuildInputs = [
    six
    requests
    infotagger
    inputstreamhelper
  ];

  passthru = {
    pythonPath = "resources/lib";
  };

  meta = with lib; {
    homepage = "https://github.com/anxdpanic/plugin.video.youtube";
    description = "YouTube is one of the biggest video-sharing websites of the world";
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
