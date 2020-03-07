{ stdenv, fetchurl, cmake, openblasCompat, gfortran, gmm, fltk, libjpeg
, zlib, libGL, libGLU, xorg, opencascade-occt }:

stdenv.mkDerivation rec {
  pname = "gmsh";
  version = "4.5.4";

  src = fetchurl {
    url = "http://gmsh.info/src/gmsh-${version}-source.tgz";
    sha256 = "1k9f7qxlwja9i40qy55070sjnr21bl165677mdqw7qyb8d7wgy6c";
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
