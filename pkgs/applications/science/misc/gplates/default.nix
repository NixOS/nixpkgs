{ lib, stdenv, fetchurl, qt4, qwt6_qt4, libGLU, libGL, glew, gdal, cgal
, proj, boost, cmake, python2, doxygen, graphviz, gmp, mpfr }:

stdenv.mkDerivation rec {
  pname = "gplates";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/gplates/${pname}-${version}-unixsrc.tar.bz2";
    sha256 = "1jrcv498vpcs8xklhbsgg12yfa90f96p2mwq6x5sjnrlpf8mh50b";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    qt4 qwt6_qt4 libGLU libGL glew gdal cgal proj python2
    doxygen graphviz gmp mpfr
    (boost.override {
      enablePython = true;
      python = python2;
    })
  ];

  NIX_CFLAGS_LINK="-ldl -lpthread -lutil";

  meta = with lib; {
    description = "Desktop software for the interactive visualisation of plate-tectonics";
    homepage = "https://www.gplates.org";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
