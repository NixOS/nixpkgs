{ lib, stdenv, fetchurl, qt4, cmake, libjpeg, libtiff, boost }:

stdenv.mkDerivation rec {
  pname = "scantailor";
  version = "0.9.12.1";

  src = fetchurl {
    url = "https://github.com/scantailor/scantailor/archive/RELEASE_${lib.replaceStrings ["."] ["_"] version}.tar.gz";
    sha256 = "1pjx3a6hs16az6rki59bchy3biy7jndjx8r125q01aq7lbf5npgg";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 libjpeg libtiff boost ];

  meta = {
    homepage = "https://scantailor.org/";
    description = "Interactive post-processing tool for scanned pages";

    license = lib.licenses.gpl3Plus;

    maintainers = [ lib.maintainers.viric ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
  };
}
