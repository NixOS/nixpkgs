{ lib, buildKodiAddon, fetchFromGitHub, requests, inputstream-adaptive, inputstreamhelper }:

buildKodiAddon rec {
  pname = "youtube";
  namespace = "plugin.video.youtube";
  version = "7.0.9.2";

  src = fetchFromGitHub {
    owner = "anxdpanic";
    repo = "plugin.video.youtube";
    rev = "v${version}";
    hash = "sha256-42BBvXIrPAAhNgrGyPTK5dgg2DACPTT6/jRUoYcihFA=";
  };

  propagatedBuildInputs = [
    requests
    inputstream-adaptive
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
