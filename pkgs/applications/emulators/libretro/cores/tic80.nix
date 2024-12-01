{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
  pkg-config,
}:
mkLibretroCore {
  core = "tic80";
  version = "0-unstable-2024-05-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "tic-80";
    rev = "6412f72d0f4725c153ce3d245729b829e713542e";
    hash = "sha256-RFp8sTSRwD+cgW3EYk3nBeY+zVKgZVQI5mjtfe2a64Q=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [
    cmake
    pkg-config
  ];
  makefile = "Makefile";
  cmakeFlags = [
    "-DBUILD_LIBRETRO=ON"
    "-DBUILD_DEMO_CARTS=OFF"
    "-DBUILD_PRO=OFF"
    "-DBUILD_PLAYER=OFF"
    "-DBUILD_SDL=OFF"
    "-DBUILD_SOKOL=OFF"
  ];
  preConfigure = "cd core";
  postBuild = "cd lib";

  meta = {
    description = "Port of TIC-80 to libretro";
    homepage = "https://github.com/libretro/tic-80";
    license = lib.licenses.mit;
  };
}
