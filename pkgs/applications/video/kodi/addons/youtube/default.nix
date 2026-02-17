{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  requests,
  inputstream-adaptive,
  inputstreamhelper,
}:

buildKodiAddon rec {
  pname = "youtube";
  namespace = "plugin.video.youtube";
  version = "7.4.0.1";

  src = fetchFromGitHub {
    owner = "anxdpanic";
    repo = "plugin.video.youtube";
    rev = "v${version}";
    hash = "sha256-8cWwsaF37tVfj3ATWVn9r2UMwQa4SZiXL3x8GW67EfE=";
  };

  propagatedBuildInputs = [
    requests
    inputstream-adaptive
    inputstreamhelper
  ];

  passthru = {
    pythonPath = "resources/lib";
  };

  meta = {
    homepage = "https://github.com/anxdpanic/plugin.video.youtube";
    description = "YouTube is one of the biggest video-sharing websites of the world";
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.kodi ];
  };
}
