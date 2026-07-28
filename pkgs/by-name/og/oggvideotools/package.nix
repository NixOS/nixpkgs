{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  fetchDebianPatch,
  libresample,
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
    # Avoid crashing in oggjoin on bogus input
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      debianRevision = "7";
      patch = "mayhem-crash-oggjoin.patch";
      hash = "sha256-0D22P+Qdf9Sfp6vptSnL4E33NVUL/XL72gNE36BF6QI=";
    })
    # Fix typos in manpages
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      debianRevision = "7";
      patch = "manual-typos.patch";
      hash = "sha256-yGzHGEADlSRnWZIN8x6xfg9ChAn8WKFQgZAJmbKtKq8=";
    })
    # Avoid crash on unknown command-line arguments
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      debianRevision = "7";
      patch = "oggThumb-zero-getopt-long.patch";
      hash = "sha256-LBgmpyyxmeAFE3zpeHRryuxboMBdBztUEGxbs0Ay+HU=";
    })
    # Prevent uninitialized read
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      debianRevision = "7";
      patch = "init-for-valgrind.patch";
      hash = "sha256-7BtdAGHHW860hFZYlRWDVfEw6CDkb18HfFROZHl+guY=";
    })
    # Fix compilation due to missing include
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      debianRevision = "7";
      patch = "import-cstring.patch";
      hash = "sha256-KMs4nyILveKY+ZmcSONmtS5+sAPPB+ypNUi9yzxBsXQ=";
    })
    # Fix out-of-bounds read
    (fetchpatch {
      url = "https://salsa.debian.org/multimedia-team/oggvideotools/-/raw/ed006e5d78f9509508dbc72277de8ab3c06d2362/debian/patches/1010-kate-header-buffer-read-past-end.patch";
      hash = "sha256-CEkNG9tHZIggCvKRPj2pKI855pVWQUdudLfpda/ZVME=";
    })
    # Fix null pointer crash (CVE-2020-21723)
    (fetchpatch {
      url = "https://salsa.debian.org/multimedia-team/oggvideotools/-/raw/122047a7cf644e282906370f277ae83b4672e5e4/debian/patches/1020-CVE-2020-21723-null-pointer-crash.patch";
      hash = "sha256-dUkMfEaB5Hn9I5+QbE/002X6ij+xIzzqjc8QTom1ITk=";
    })
    # Unbundle libresample
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/oggvideotools/raw/23f918f39278d87adb5a5ab2e57d5cc1816e1e8a/f/0005-unbundle-libresample.patch";
      hash = "sha256-JSuH8ScYBi6zAgEhrFdPOGCSXzDk+lEnSHX9wuctAsg=";
    })
    # Fix buffer overflow (CVE-2020-21724)
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/oggvideotools/raw/2dd078ea81773a34cc0c4817ebbf3c4038b8098c/f/stream-serializer.diff";
      hash = "sha256-3HkAuCBaNjKoTN8Q3oW89e3zXo13Ev5g7VJ/RPO3zRA=";
    })
  ];

  postPatch = ''
    # Don't disable optimisations
    substituteInPlace CMakeLists.txt --replace-fail " -O0 " ""
  ''
  # Fix "src/effect/pictureBlend.cpp:28:11: error: no matching conversion for functional-style cast from 'const char[39]' to 'OggException'"
  + (lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i '1i #include <string>' src/effect/pictureBlend.cpp
  '');

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    gd
    libogg
    libresample
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
  };
})
