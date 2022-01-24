{ lib, stdenv, fetchurl, cmake, qt4, zlib, eigen, openbabel, pkg-config, libGLU, libGL, libX11, doxygen }:

stdenv.mkDerivation rec {
  pname = "avogadro";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/avogadro/avogadro-${version}.tar.bz2";
    sha256 = "050ag9p4vg7jg8hj1wqfv7lsm6ar2isxjw2vw85s49vsl7g7nvzy";
  };

  buildInputs = [ qt4 eigen zlib openbabel libGL libGLU libX11 ];

  nativeBuildInputs = [ cmake pkg-config doxygen ];

  NIX_CFLAGS_COMPILE = "-include ${libGLU.dev}/include/GL/glu.h";

  patches = [
    (fetchurl {
      url = "https://data.gpo.zugaina.org/fusion809/sci-chemistry/avogadro/files/avogadro-1.1.0-xlibs.patch";
      sha256 = "1p113v19z3zwr9gxj2k599f8p97a8rwm93pa4amqvd0snn31mw0k";
    })
  ];

  meta = with lib; {
    description = "Molecule editor and visualizer";
    maintainers = with maintainers; [ danielbarter ];
    platforms = platforms.mesaPlatforms;
  };
}
