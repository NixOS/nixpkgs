{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, openssl, rtmpdump, zlib }:

buildKodiBinaryAddon rec {
  pname = "inputstream-rtmp";
  namespace = "inputstream.rtmp";
  version = "20.3.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.rtmp";
    rev = "${version}-${rel}";
    sha256 = "sha256-VF2DpQXXU+rj76e/de5YB1T7dzeOjmO0dpsPVqEnMy4=";
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
