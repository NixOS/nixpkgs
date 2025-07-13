{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libestr";
  version = "0.1.11";

  src = fetchurl {
    url = "https://libestr.adiscon.com/files/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  meta = with lib; {
    homepage = "https://libestr.adiscon.com/";
    description = "Some essentials for string handling";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
