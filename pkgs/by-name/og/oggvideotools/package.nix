{ lib, stdenv, fetchurl, fetchpatch, cmake, pkg-config, boost, gd, libogg, libtheora, libvorbis }:

stdenv.mkDerivation rec {
  pname = "oggvideotools";
  version = "0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/oggvideotools/oggvideotools/oggvideotools-${version}/oggvideotools-${version}.tar.bz2";
    sha256 = "sha256-2dv3iXt86phhIgnYC5EnRzyX1u5ssNzPwrOP4+jilSM=";
  };

  patches = [
    # Fix pending upstream inclusion for missing includes:
    #  https://sourceforge.net/p/oggvideotools/bugs/12/
    (fetchpatch {
      name = "gcc-10.patch";
      url = "https://sourceforge.net/p/oggvideotools/bugs/12/attachment/fix-compile.patch";
      sha256 = "sha256-mJttoC3jCLM3vmPhlyqh+W0ryp2RjJGIBXd6sJfLJA4=";
    })

    # Fix pending upstream inclusion for build failure on gcc-12:
    #  https://sourceforge.net/p/oggvideotools/bugs/13/
    (fetchpatch {
      name = "gcc-12.patch";
      url = "https://sourceforge.net/p/oggvideotools/bugs/13/attachment/fix-gcc-12.patch";
      sha256 = "sha256-zuDXe86djWkR8SgYZHkuAJJ7Lf2VYsVRBrlEaODtMKE=";
      # svn patch, rely on prefix added by fetchpatch:
      extraPrefix = "";
    })

    # Fixes compilation on Clang:
    # src/effect/pictureBlend.cpp:28:11: error: no matching conversion for functional-style cast from 'const char[39]' to 'OggException'
    #
    # For some reason this is required on Clang but not GCC, most other files have string.h included via other headers anyways.
    ./fix-clang.patch
  ];

  postPatch = ''
    # Don't disable optimisations
    substituteInPlace CMakeLists.txt --replace " -O0 " ""

    # Remove hardcoding of -std= to fix builds on Clang (which doesn't like -std=
    # being passed when compiling C), because I can't figure out this CMake
    # (It should be as simple as adding target_compile_features, but no, since they
    # don't actually define a target?)
    substituteInPlace CMakeLists.txt --replace-fail " --std=c++0x" ""
  '';

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-std=c++0x"
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ boost gd libogg libtheora libvorbis ];

  meta = with lib; {
    description = "Toolbox for manipulating and creating Ogg video files";
    homepage = "http://www.streamnik.de/oggvideotools.html";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
