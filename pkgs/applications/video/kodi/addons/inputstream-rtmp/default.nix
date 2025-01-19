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
  version = "21.1.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.rtmp";
    rev = "${version}-${rel}";
    sha256 = "sha256-M6LFokWQRzBZ7inzRsMxyWzkV0XsGHh4d0CPhv1NCfI=";
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
    maintainers = lib.teams.kodi.members;
  };
}
