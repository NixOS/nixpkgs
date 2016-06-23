{ stdenv, fetchurl, cmake, blas, liblapack, gfortran, fltk, libjpeg
, zlib, mesa, mesa_glu, xorg }:

let version = "2.12.0"; in

stdenv.mkDerivation {
  name = "gmsh-${version}";

  src = fetchurl {
    url = "http://gmsh.info/src/gmsh-${version}-source.tgz";
    sha256 = "02cx2mfbxx6m18s54z4yzbk4ybch3v9489z7cr974y8y0z42xgbz";
  };

  # The original CMakeLists tries to use some version of the Lapack lib
  # that is supposed to work without Fortran but didn't for me.
  patches = [ ./CMakeLists.txt.patch ];

  buildInputs = [ cmake blas liblapack gfortran fltk libjpeg zlib mesa
    mesa_glu xorg.libXrender xorg.libXcursor xorg.libXfixes xorg.libXext
    xorg.libXft xorg.libXinerama xorg.libX11 xorg.libSM xorg.libICE
  ];

  meta = {
    description = "A three-dimensional finite element mesh generator";
    homepage = http://gmsh.info/;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
