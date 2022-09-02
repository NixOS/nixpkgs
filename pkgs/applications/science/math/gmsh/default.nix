{ lib, stdenv, fetchurl, cmake, blas, lapack, gfortran, gmm, fltk, libjpeg
, zlib, libGL, libGLU, xorg, opencascade-occt }:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "gmsh";
  version = "4.10.5";

  src = fetchurl {
    url = "https://gmsh.info/src/gmsh-${version}-source.tgz";
    sha256 = "sha256-zAMMWu5l59WPhQuLb1WmiUXIm8hx+U4SOSefWiEPxOo=";
  };

  buildInputs = [
    blas lapack gmm fltk libjpeg zlib opencascade-occt
  ] ++ lib.optionals (!stdenv.isDarwin) [
    libGL libGLU xorg.libXrender xorg.libXcursor xorg.libXfixes
    xorg.libXext xorg.libXft xorg.libXinerama xorg.libX11 xorg.libSM
    xorg.libICE
  ];

  nativeBuildInputs = [ cmake gfortran ];

  doCheck = true;

  meta = {
    description = "A three-dimensional finite element mesh generator";
    homepage = "https://gmsh.info/";
    license = lib.licenses.gpl2Plus;
  };
}
