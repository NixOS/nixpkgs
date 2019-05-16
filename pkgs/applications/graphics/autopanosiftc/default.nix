{stdenv, fetchurl, cmake, libpng, libtiff, libjpeg, panotools, libxml2 }:

stdenv.mkDerivation {
  name = "autopano-sift-C-2.5.1";

  src = fetchurl {
    url = mirror://sourceforge/hugin/autopano-sift-C-2.5.1.tar.gz;
    sha256 = "0dqk8ff82gmy4v5ns5nr9gpzkc1p7c2y8c8fkid102r47wsjk44s";
  };

  buildInputs = [ cmake libpng libtiff libjpeg panotools libxml2 ];

  patches = [
    (fetchurl {
      url = https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/autopano-sift-C/files/autopano-sift-C-2.5.1-lm.patch;
      sha256 = "1bfcr5sps0ip9gl4jprji5jgf9wkczz6d2clsjjlbsy8r3ixi3lv";
    })
  ];

  meta = {
    homepage = http://hugin.sourceforge.net/;
    description = "Implementation in C of the autopano-sift algorithm for automatically stitching panoramas";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
