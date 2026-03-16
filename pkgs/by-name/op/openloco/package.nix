{
  lib,
  fetchFromGitHub,
  fetchurl,
  pkgsi686Linux,
}:
let
  sfl-src = fetchFromGitHub {
    owner = "slavenf";
    repo = "sfl-library";
    tag = "2.0.2";
    hash = "sha256-C8BRl77fryD1aNW6ASD/orb8+hrAKBqmXjr2Z4JqX94=";
  };

  openloco-objects = fetchurl {
    url = "https://github.com/OpenLoco/OpenGraphics/releases/download/v0.1.5/objects.zip";
    sha256 = "fe8943fabad8eb07cebab5354589abd7e798a705f7993bb4d9dab2122b4fe96e";
  };

in
pkgsi686Linux.stdenv.mkDerivation rec {
  pname = "openloco";
  version = "25.11";

  src = fetchFromGitHub {
    owner = "OpenLoco";
    repo = "OpenLoco";
    tag = "v${version}";
    hash = "sha256-ohHTa5ow6wiq0GajqLcOwL9mnjocw+Od93SEaxCR2C0=";
  };

  postPatch = ''
    # the upstream build process determines the version tag from git; since we
    # are not using a git checkout, we patch it manually
    sed -i '/#define OPENLOCO_NAME "OpenLoco"/a#define OPENLOCO_VERSION_TAG "${version}"' src/OpenLoco/src/Version.cpp

    # prefetch sfl header sources
    grep -q 'GIT_TAG \+${sfl-src.tag}' thirdparty/CMakeLists.txt
    sed -i 's#GIT_REPOSITORY \+https://github.com/slavenf/sfl-library#SOURCE_DIR ${sfl-src}#' thirdparty/CMakeLists.txt

    # prefetch openloco-objects
    sed -i 's#URL \+${openloco-objects.url}#URL ${openloco-objects}#' CMakeLists.txt
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=null-dereference";

  cmakeFlags = [
    "-DOPENLOCO_BUILD_TESTS=NO"
  ];

  nativeBuildInputs = [
    pkgsi686Linux.cmake
    pkgsi686Linux.pkg-config
  ];

  buildInputs = [
    pkgsi686Linux.SDL2
    pkgsi686Linux.libpng
    pkgsi686Linux.libzip
    pkgsi686Linux.openal
    pkgsi686Linux.yaml-cpp
    pkgsi686Linux.fmt_11
    pkgsi686Linux.libx11
  ];

  meta = {
    description = "Open source re-implementation of Chris Sawyer's Locomotion";
    homepage = "https://github.com/OpenLoco/OpenLoco";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ icewind1991 ];
    mainProgram = "OpenLoco";
  };
}
