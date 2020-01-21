{ stdenv, fetchurl, cmake, openblasCompat, gfortran, gmm, fltk, libjpeg
, zlib, libGL, libGLU, xorg, opencascade-occt }:

stdenv.mkDerivation rec {
  pname = "gmsh";
  version = "4.5.1";

  src = fetchurl {
    url = "http://gmsh.info/src/gmsh-${version}-source.tgz";
    sha256 = "0rjwxpz5qwq6dj7ka53mhxlgnp9bs5jphhsamlb0nk3h8kzckisq";
  };

  buildInputs = [ openblasCompat gmm fltk libjpeg zlib libGLU libGL
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
