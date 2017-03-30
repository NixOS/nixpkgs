{ stdenv, fetchurl, cmake, qt4, zlib, eigen, openbabel, pkgconfig, mesa, libX11, doxygen }:

stdenv.mkDerivation rec {
  name = "avogadro-1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/avogadro/${name}.tar.bz2";
    sha256 = "050ag9p4vg7jg8hj1wqfv7lsm6ar2isxjw2vw85s49vsl7g7nvzy";
  };

  buildInputs = [ qt4 eigen zlib openbabel mesa libX11 ];

  nativeBuildInputs = [ cmake pkgconfig doxygen ];

  NIX_CFLAGS_COMPILE = "-include ${mesa}/include/GL/glu.h";

  meta = {
    description = "Molecule editor and visualizer";
    maintainers = [ ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
