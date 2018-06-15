{ stdenv, fetchurl, cmake, blas, liblapack, gfortran, gmm, fltk, libjpeg
, zlib, libGLU_combined, libGLU, xorg }:

let version = "3.0.6"; in

stdenv.mkDerivation {
  name = "gmsh-${version}";

  src = fetchurl {
    url = "http://gmsh.info/src/gmsh-${version}-source.tgz";
    sha256 = "0ywqhr0zmdhn8dvi6l8z1vkfycyv67fdrz6b95mb39np832bq04p";
  };

  # The original CMakeLists tries to use some version of the Lapack lib
  # that is supposed to work without Fortran but didn't for me.
  patches = [ ./CMakeLists.txt.patch ];

  buildInputs = [ cmake blas liblapack gmm fltk libjpeg zlib libGLU_combined
    libGLU xorg.libXrender xorg.libXcursor xorg.libXfixes xorg.libXext
    xorg.libXft xorg.libXinerama xorg.libX11 xorg.libSM xorg.libICE
  ];

  nativeBuildInputs = [ gfortran ];

  enableParallelBuilding = true;

  meta = {
    description = "A three-dimensional finite element mesh generator";
    homepage = http://gmsh.info/;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
