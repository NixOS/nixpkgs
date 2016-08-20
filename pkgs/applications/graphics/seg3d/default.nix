{ fetchurl, stdenv, cmake, wxGTK, itk, libGLU_combined, libXft, libXext, libXi, zlib, libXmu,
libuuid }:

assert (stdenv ? glibc);

stdenv.mkDerivation {
  name = "seg3d-1.12_20090930";
  src = fetchurl {
    url = https://www.sci.utah.edu/releases/seg3d_v1.12/Seg3D_1.12_20090930_source.tgz;
    sha256 = "1wr6rc6v5qjjkmws8yrc03z35h3iydxk1z28p06v1wdnca0y71z8";
  };

  patches = [ ./cstdio.patch ];

  cmakeFlags = {
    M_LIBRARY = "${stdenv.glibc.out}/lib/libm.so";
    DL_LIBRARY = "${stdenv.glibc.out}/lib/libdl.so";
    BUILD_UTILS = true;
    BUILD_SEG3D = true;
    BUILD_DATAFLOW = false;
    BUILD_SHARED_LIBS = false;
    WITH_X11 = true;
    BUILD_BIOMESH3D = true;
    WITH_TETGEN = true;
    BUILD_TYPE = "Release";
    BUILD_TESTING = false;
    WITH_WXWIDGETS = true;
    ITK_DIR = "${itk}/lib/InsightToolkit";
    GDCM_LIBRARY = "${itk}/lib/libitkgdcm.a";
  };


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

  buildInputs = [ cmake wxGTK itk libGLU_combined libXft libXext libXi zlib libXmu libuuid ];

  meta = {
    broken = true;
  };
}
