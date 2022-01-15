{ lib, rel, buildKodiBinaryAddon, fetchFromGitHub, openssl, rtmpdump, zlib }:

buildKodiBinaryAddon rec {
  pname = "inputstream-rtmp";
  namespace = "inputstream.rtmp";
  version = "19.0.1";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "inputstream.rtmp";
    rev = "${version}-${rel}";
    sha256 = "sha256-BNc9HJ4Yq1WTxTr7AUHBB9yDz8oefy2EtFRwVYVGcaY=";
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
