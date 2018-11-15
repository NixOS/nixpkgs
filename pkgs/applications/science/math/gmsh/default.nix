{ stdenv, fetchurl, cmake, openblasCompat, gfortran, gmm, fltk, libjpeg
, zlib, libGLU_combined, libGLU, xorg }:

let version = "4.0.4"; in

stdenv.mkDerivation {
  name = "gmsh-${version}";

  src = fetchurl {
    url = "http://gmsh.info/src/gmsh-${version}-source.tgz";
    sha256 = "1hvrls3xyxvn69kwicpvndrs0zhifcfkhfsxr8zkmhmn6fhnjhha";
  };

  buildInputs = [ cmake openblasCompat gmm fltk libjpeg zlib libGLU_combined
    libGLU xorg.libXrender xorg.libXcursor xorg.libXfixes xorg.libXext
    xorg.libXft xorg.libXinerama xorg.libX11 xorg.libSM xorg.libICE
  ];

  nativeBuildInputs = [ gfortran ];

  enableParallelBuilding = true;

  meta = {
    description = "A three-dimensional finite element mesh generator";
    homepage = http://gmsh.info/;
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
