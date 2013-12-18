{stdenv, fetchurl, cmake, libpng, libtiff, libjpeg, panotools, libxml2 }:

stdenv.mkDerivation {
  name = "autopano-sift-C-2.5.1";

  src = fetchurl {
    url = mirror://sourceforge/hugin/autopano-sift-C-2.5.1.tar.gz;
    sha256 = "0dqk8ff82gmy4v5ns5nr9gpzkc1p7c2y8c8fkid102r47wsjk44s";
  };

  buildInputs = [ cmake libpng libtiff libjpeg panotools libxml2 ];

  meta = {
    homepage = http://hugin.sourceforge.net/;
    description = "Implementation in C of the autopano-sift algorithm for automatically stitching panoramas";
    license = "GPLv2";
  };
}
