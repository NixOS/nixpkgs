{stdenv, fetchurl, qt4, cmake, libjpeg, libtiff, boost }:

stdenv.mkDerivation rec {
  name = "scantailor-0.9.12.1";

  src = fetchurl {
    url = "https://github.com/scantailor/scantailor/archive/RELEASE_0_9_12_1.tar.gz";
    sha256 = "1pjx3a6hs16az6rki59bchy3biy7jndjx8r125q01aq7lbf5npgg";
  };

  buildInputs = [ qt4 cmake libjpeg libtiff boost ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://scantailor.org/;
    description = "Interactive post-processing tool for scanned pages";

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;
  };
}
