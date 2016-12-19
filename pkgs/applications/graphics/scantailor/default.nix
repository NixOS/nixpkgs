{stdenv, fetchurl, qt4, cmake, libjpeg, libtiff, boost }:

stdenv.mkDerivation rec {
  name = "scantailor-0.9.11.1";

  src = fetchurl {
    url = "https://github.com/scantailor/scantailor/archive/RELEASE_0_9_11_1.tar.gz";
    sha256 = "1z06yg228r317m8ab3mywg0wbpj0x2llqj187bh4g3k4xc2fcm8m";
  };

  buildInputs = [ qt4 cmake libjpeg libtiff boost ];

  meta = {
    homepage = http://scantailor.org/;
    description = "Interactive post-processing tool for scanned pages";

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
