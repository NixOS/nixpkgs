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

  meta = with lib; {
    homepage = "https://github.com/xbmc/inputstream.rtmp/";
    description = "Client for RTMP streams";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    teams = [ teams.kodi ];
  };
}
