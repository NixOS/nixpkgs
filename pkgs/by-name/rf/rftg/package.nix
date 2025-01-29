{ lib, stdenv, fetchurl, gtk2, pkg-config }:

stdenv.mkDerivation rec {

  pname = "rftg";
  version = "0.9.4";

  src = fetchurl {
    url = "http://keldon.net/rftg/rftg-${version}.tar.bz2";
    sha256 = "0j2y6ggpwdlvyqhirp010aix2g6aacj3kvggvpwzxhig30x9vgq8";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2.dev ];

  meta = {
    homepage = "http://keldon.net/rftg/";
    description = "Implementation of the card game Race for the Galaxy, including an AI";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.falsifian ];
  };

}
