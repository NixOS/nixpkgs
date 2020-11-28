{ stdenv, fetchurl, cmake, blas, lapack, gfortran, gmm, fltk, libjpeg
, zlib, libGL, libGLU, xorg, opencascade-occt }:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "gmsh";
  version = "4.7.0";

  src = fetchurl {
    url = "http://gmsh.info/src/gmsh-${version}-source.tgz";
    sha256 = "03ij2hnh393gw59hgrz3qrmgc4qw82bc9nd98sks4jrp5gwk4zz2";
  };

  buildInputs = [ blas lapack gmm fltk libjpeg zlib libGLU libGL
    libGLU xorg.libXrender xorg.libXcursor xorg.libXfixes xorg.libXext
    xorg.libXft xorg.libXinerama xorg.libX11 xorg.libSM xorg.libICE
    opencascade-occt
  ];

  nativeBuildInputs = [ cmake gfortran ];

  meta = {
    description = "A three-dimensional finite element mesh generator";
    homepage = "http://gmsh.info/";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
