{stdenv, fetchurl, cmake, libpng, libtiff, libjpeg, panotools, libxml2 }:

stdenv.mkDerivation {
  name = "autopano-sift-C-2.5.0";

  src = fetchurl {
    url = mirror://sourceforge/hugin/autopano-sift-C-2.5.0.tar.gz;
    sha256 = "0pvkapjg7qdkjg151wjc7islly9ag8fg6bj0g5nbllv981ixjql3";
  };

  buildInputs = [ cmake libpng libtiff libjpeg panotools libxml2 ];

  meta = {
    homepage = http://hugin.sourceforge.net/;
    description = "Implementation in C of the autopano-sift algorithm for automatically stitching panoramas";
    license = "GPLv2";
  };
}
