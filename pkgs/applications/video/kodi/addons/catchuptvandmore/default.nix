{ lib, buildKodiAddon, fetchFromGitHub, addonUpdateScript, requests
, inputstreamhelper, kodi-six, six, youtube-dl, codequick, pytz, pyqrcode
, tzlocal, future, catchuptvandmore-images }:

buildKodiAddon rec {
  pname = "catchuptvandmore";
  namespace = "plugin.video.catchuptvandmore";
  version = "v0.2.38";

  src = fetchFromGitHub {
    owner = "Catch-up-TV-and-More";
    repo = "plugin.video.catchuptvandmore";
    rev = "9ffa2aa80a9d4f8cbfd3b37ee6bf287487a9d280";
    hash = "sha256-ayQaV1m0AllGpZjAD1NyttbrLdiZlwi1HWXhMpKcNug=";
  };

  propagatedBuildInputs = [
    pyqrcode
    pytz
    requests
    inputstreamhelper
    kodi-six
    six
    youtube-dl
    codequick
    tzlocal
    future
    catchuptvandmore-images
  ];

  meta = with lib; {
    homepage =
      "https://github.com/Catch-up-TV-and-More/plugin.video.catchuptvandmore";
    description = "Replay, Live TV and websites videos addon for Kodi";
    license = licenses.gpl2;
    maintainers = teams.kodi.members;
  };
}
