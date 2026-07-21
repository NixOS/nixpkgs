{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  openssl,
  rtmpdump,
  zlib,
}:

buildKodiBinaryAddon rec {
  pname = "inputstream-rtmp";
  namespace = "inputstream.rtmp";
  version = "21.1.2";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.rtmp";
    rev = "${version}-${rel}";
    sha256 = "sha256-AkpRbYOe30dWDcflCGXxJz8Y+9bQw9ZmZF88ra2c+fc=";
  };

  extraBuildInputs = [
    openssl
    rtmpdump
    zlib
  ];

  meta = {
    homepage = "https://github.com/xbmc/inputstream.rtmp/";
    description = "Client for RTMP streams";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.kodi ];
  };
}
