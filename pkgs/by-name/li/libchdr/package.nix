{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zlib,
  zstd,
}:

stdenv.mkDerivation {
  __structuredAttrs = true;

  pname = "libchdr";
  version = "0-unstable-2025-12-27";

  src = fetchFromGitHub {
    owner = "rtissera";
    repo = "libchdr";
    rev = "07a7dad23378b001f4ab174ef51bd6553f883edd";
    hash = "sha256-FCZ442mDF/pO5sNHNcPtWxSOB8o3I0YwwNXzu1B2vVQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    zlib
    zstd
  ];

  cmakeEntries = {
    BUILD_SHARED_LIBS = !stdenv.hostPlatform.isStatic;
    INSTALL_STATIC_LIBS = stdenv.hostPlatform.isStatic;
    WITH_SYSTEM_ZLIB = true;
    WITH_SYSTEM_ZSTD = true;
    CMAKE_INSTALL_LIBDIR = "lib";
    CMAKE_INSTALL_INCLUDEDIR = "include";
  };

  meta = {
    description = "Standalone library for reading MAME's CHDv1-v5 formats";
    homepage = "https://github.com/rtissera/libchdr";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.all;
  };
}
