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

  cmakeFlags = with lib.strings; [
    (cmakeBool "BUILD_LIBRETRO" true)
    (cmakeBool "BUILD_DEMO_CARTS" false)
    (cmakeBool "BUILD_PRO" false)
    (cmakeBool "BUILD_PLAYER" false)
    (cmakeBool "BUILD_SDL" false)
    (cmakeBool "BUILD_SOKOL" false)
    # Workaround the following error:
    # > CMake Error at 3rdparty/libzip/libzip/CMakeLists.txt:1 (cmake_minimum_required):
    # > Compatibility with CMake < 3.5 has been removed from CMake.
    #
    # > Update the VERSION argument <min> value.  Or, use the <min>...<max> syntax
    # > to tell CMake that the project requires at least <min> but has been updated
    # > to work with policies introduced by <max> or earlier.
    #
    # > Or, add -DCMAKE_POLICY_VERSION_MINIMUM=3.5 to try configuring anyway.
    (cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  preConfigure = "cd core";

  postBuild = "cd lib";

  meta = {
    description = "Port of TIC-80 to libretro";
    homepage = "https://github.com/libretro/tic-80";
    license = lib.licenses.mit;
  };
}
