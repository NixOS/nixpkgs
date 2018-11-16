{ stdenv, fetchurl, qt4, qwt6_qt4, libGLU_combined, glew, gdal_1_11, cgal
, proj, boost, cmake, python2, doxygen, graphviz, gmp }:

stdenv.mkDerivation rec {
  name = "gplates-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/gplates/${name}-unixsrc.tar.bz2";
    sha256 = "02scnjj5nlc2d2c8lbx0xvj8gg1bgkjliv3wxsx564c55a9x69qw";
  };

  patches = [
    ./boostfix.patch
  ];

  buildInputs = [
    qt4 qwt6_qt4 libGLU_combined glew gdal_1_11 cgal proj boost cmake python2
    doxygen graphviz gmp
  ];

  meta = with stdenv.lib; {
    description = "Desktop software for the interactive visualisation of plate-tectonics";
    homepage = https://www.gplates.org;
    license = licenses.gpl2;
    platforms = platforms.all;
    broken = true;
  };
}
