{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "rlog";
  version = "1.4";

  src = fetchurl {
    url = "http://rlog.googlecode.com/files/rlog-${version}.tar.gz";
    sha256 = "0y9zg0pd7vmnskwac1qdyzl282z7kb01nmn57lsg2mjdxgnywf59";
  };

  meta = with lib; {
    homepage = "https://www.arg0.net/rlog";
    description = "C++ logging library used in encfs";
    platforms = platforms.linux;
    license = licenses.lgpl3;
  };
}
