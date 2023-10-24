{ lib, buildKodiAddon, fetchFromGitHub, addonUpdateScript, requests
, inputstreamhelper, kodi-six, six, youtube-dl, codequick, pytz, pyqrcode
, tzlocal, future, catchuptvandmore-images, inputstream-adaptive }:

buildKodiAddon rec {
  pname = "catchuptvandmore";
  namespace = "plugin.video.catchuptvandmore";
  version = "v0.2.38";

  src = fetchFromGitHub {
    owner = "Catch-up-TV-and-More";
    repo = "plugin.video.catchuptvandmore";
    rev = "b8fd0772e5197be8803b983b5de559a1ddd7da1d";
    hash = "sha256-lsEv7h2Xo1ML85RBGRczagkHhYEy/5hQTmOMq+sPDg0=";
  };

  propagatedBuildInputs = [
    pyqrcode
    pytz
    requests
    inputstreamhelper
    inputstream-adaptive
    kodi-six
    six
    youtube-dl
    codequick
    tzlocal
    future
    catchuptvandmore-images
  ];

  passthru = { pythonPath = "resources/lib"; };

  meta = with lib; {
    homepage =
      "https://github.com/Catch-up-TV-and-More/plugin.video.catchuptvandmore";
    description = "Replay, Live TV and websites videos addon for Kodi";
    license = licenses.gpl2;
    maintainers = teams.kodi.members;
  };
}
