{ fetchurl, stdenv, cmake, wxGTK, itk, mesa, libXft, libXext, libXi, zlib, libXmu }:

assert (stdenv ? glibc);

stdenv.mkDerivation {
  name = "seg3d-1.12";
  src = fetchurl {
    url = http://www.sci.utah.edu/releases/seg3d_v1.12/Seg3D_1.12_20090930_source.tgz;
    sha256 = "1wr6rc6v5qjjkmws8yrc03z35h3iydxk1z28p06v1wdnca0y71z8";
  };

  patches = [ ./cstdio.patch ];

  cmakeFlags = [ "-DM_LIBRARY=${stdenv.glibc}/lib/libm.so"
    "-DDL_LIBRARY=${stdenv.glibc}/lib/libdl.so" ];

  preBuild = ''
    export LD_LIBRARY_PATH=`pwd`/lib
  '';

  preUnpack = ''
    set -x
    sourceRoot=`pwd`/src
  '';

  buildInputs = [ cmake wxGTK itk mesa libXft libXext libXi zlib libXmu ];
}
