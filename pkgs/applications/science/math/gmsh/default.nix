{ stdenv, fetchurl, cmake, openblasCompat, gfortran, gmm, fltk, libjpeg
, zlib, libGL, libGLU, xorg, opencascade-occt }:

stdenv.mkDerivation rec {
  pname = "gmsh";
  version = "4.5.2";

  src = fetchurl {
    url = "http://gmsh.info/src/gmsh-${version}-source.tgz";
    sha256 = "10i6i1s68lkccnl73lzr04cf1hc5rd8b7dpiaxs1vzrj1ljgw801";
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
