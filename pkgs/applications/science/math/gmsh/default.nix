{ stdenv, fetchurl, cmake, blas, liblapack, gfortran, gmm, fltk, libjpeg
, zlib, libGLU_combined, libGLU, xorg }:

let version = "4.0.2"; in

stdenv.mkDerivation {
  name = "gmsh-${version}";

  src = fetchurl {
    url = "http://gmsh.info/src/gmsh-${version}-source.tgz";
    sha256 = "03aw3sbz4x998rk29az7mgm0mrdb6614aqnppg81p5jkh5097jgk";
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
