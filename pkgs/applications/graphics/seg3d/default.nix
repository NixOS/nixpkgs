{ fetchurl, stdenv, cmake, wxGTK, itk, mesa, libXft, libXext, libXi, zlib, libXmu,
libuuid }:

assert (stdenv ? glibc);

stdenv.mkDerivation {
  name = "seg3d-1.12_20090930";
  src = fetchurl {
    url = http://www.sci.utah.edu/releases/seg3d_v1.12/Seg3D_1.12_20090930_source.tgz;
    sha256 = "1wr6rc6v5qjjkmws8yrc03z35h3iydxk1z28p06v1wdnca0y71z8";
  };

  patches = [ ./cstdio.patch ];

  cmakeFlags = [
    "-DM_LIBRARY=${stdenv.glibc.out}/lib/libm.so"
    "-DDL_LIBRARY=${stdenv.glibc.out}/lib/libdl.so"
    "-DBUILD_UTILS=1"
    "-DBUILD_SEG3D=1"
    "-DBUILD_DATAFLOW=0"
    "-DBUILD_SHARED_LIBS=0"
    "-DWITH_X11=1"
    "-DBUILD_BIOMESH3D=1"
    "-DWITH_TETGEN=1"
    "-DBUILD_TYPE=Release"
    "-DBUILD_TESTING=0"
    "-DWITH_WXWIDGETS=ON"
    "-DITK_DIR=${itk}/lib/InsightToolkit"
    "-DGDCM_LIBRARY=${itk}/lib/libitkgdcm.a"
  ];


  makeFlags = "VERBOSE=1";

  preBuild = ''
    export LD_LIBRARY_PATH=`pwd`/lib
    export NIX_LDFLAGS="$NIX_LDFLAGS -lGLU -lSM -lICE -lX11 -lXext -luuid";
  '';

  preUnpack = ''
    set -x
    sourceRoot=`pwd`/src
  '';

  postInstall = ''
    cp Seg3D $out/bin
    exit 1
  '';

  buildInputs = [ cmake wxGTK itk mesa libXft libXext libXi zlib libXmu libuuid ];
}
