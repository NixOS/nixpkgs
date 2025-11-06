{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  pkg-config,
  boost,
  gd,
  libogg,
  libtheora,
  libvorbis,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oggvideotools";
  version = "0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/oggvideotools/oggvideotools/oggvideotools-${finalAttrs.version}/oggvideotools-${finalAttrs.version}.tar.bz2";
    hash = "sha256-2dv3iXt86phhIgnYC5EnRzyX1u5ssNzPwrOP4+jilSM=";
  };

  patches = [
    # Fix pending upstream inclusion for missing includes:
    #  https://sourceforge.net/p/oggvideotools/bugs/12/
    (fetchpatch {
      name = "gcc-10.patch";
      url = "https://sourceforge.net/p/oggvideotools/bugs/12/attachment/fix-compile.patch";
      hash = "sha256-mJttoC3jCLM3vmPhlyqh+W0ryp2RjJGIBXd6sJfLJA4=";
    })

    # Fix pending upstream inclusion for build failure on gcc-12:
    #  https://sourceforge.net/p/oggvideotools/bugs/13/
    (fetchpatch {
      name = "gcc-12.patch";
      url = "https://sourceforge.net/p/oggvideotools/bugs/13/attachment/fix-gcc-12.patch";
      hash = "sha256-zuDXe86djWkR8SgYZHkuAJJ7Lf2VYsVRBrlEaODtMKE=";
      # svn patch, rely on prefix added by fetchpatch:
      extraPrefix = "";
    })
  ];

  postPatch = ''
    # Don't disable optimisations
    substituteInPlace CMakeLists.txt --replace " -O0 " ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    gd
    libogg
    libtheora
    libvorbis
  ];

  cmakeFlags = [
    # fix compatibility with CMake (https://cmake.org/cmake/help/v4.0/command/cmake_minimum_required.html)
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "4.0")
  ];

  meta = {
    description = "Toolbox for manipulating and creating Ogg video files";
    homepage = "https://sourceforge.net/projects/oggvideotools/";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    # Compilation error on Darwin:
    # error: invalid argument '--std=c++0x' not allowed with 'C'
    # make[2]: *** [src/libresample/CMakeFiles/resample.dir/build.make:76: src/libresample/CMakeFiles/resample.dir/filterkit.c.o] Error 1
    broken = stdenv.hostPlatform.isDarwin;
  };
})
