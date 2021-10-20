{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, openssl, rtmpdump, zlib }:

buildKodiBinaryAddon rec {
  pname = "inputstream-rtmp";
  namespace = "inputstream.rtmp";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.rtmp";
    rev = "${version}-${rel}";
    sha256 = "1q4k6plkjasnjs7gnbcc1x2mwr562ach7bkqk1z1y343s0dp9qnq";
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
