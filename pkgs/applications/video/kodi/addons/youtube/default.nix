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
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "anxdpanic";
    repo = "plugin.video.youtube";
    rev = "v${version}";
    hash = "sha256-IEfgpl/uuELQ+4dVqek7/iCHW+sooVZ5eiASNXnm5EA=";
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
