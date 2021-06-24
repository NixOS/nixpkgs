{ lib, stdenv, fetchurl, cmake, blas, lapack, gfortran, gmm, fltk, libjpeg
, zlib, libGL, libGLU, xorg, opencascade-occt }:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "gmsh";
  version = "4.8.1";

  src = fetchurl {
    url = "http://gmsh.info/src/gmsh-${version}-source.tgz";
    sha256 = "sha256-1QOPXyWuhZc1NvsFzIhv6xvX1n4mBanYeJvMJSj6izU=";
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
    license = lib.licenses.gpl2Plus;
  };
}
