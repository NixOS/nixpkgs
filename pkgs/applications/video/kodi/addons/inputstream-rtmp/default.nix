{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, openssl, rtmpdump, zlib }:

buildKodiBinaryAddon rec {
  pname = "inputstream-rtmp";
  namespace = "inputstream.rtmp";
  version = "19.0.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.rtmp";
    rev = "${version}-${rel}";
    sha256 = "sha256-76yGttcLJJ5XJKsFJ3GnEuPs9+9J0Tr8Znm45676OI8=";
  };

  extraBuildInputs = [ openssl rtmpdump zlib ];

  meta = with lib; {
    homepage = "https://github.com/xbmc/inputstream.rtmp/";
    description = "Client for RTMP streams";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = teams.kodi.members;
  };
}
