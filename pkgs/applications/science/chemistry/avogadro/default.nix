{ stdenv, fetchFromGitHub, cmake, qt4, zlib, eigen, openbabel, pkgconfig, mesa, libX11, doxygen }:

stdenv.mkDerivation rec {
  name = "avogadro-1.2";

  src = fetchFromGitHub {
    owner = "cryos";
    repo = "avogadro";
    rev = "8ac8408ac6113d375cdcaf233f89854a23fa280c";
    sha256 = "00mvkjdgsw6g8d2jwgfsin2r1my1pgh78p8p9ywvsvl4syc476fv";
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
