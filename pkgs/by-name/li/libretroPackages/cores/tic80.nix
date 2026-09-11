{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
  pkg-config,
}:
mkLibretroCore {
  core = "tic80";
  version = "0-unstable-2026-09-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "tic-80";
    rev = "14fd99edc29962778bc88d81773288ffc6e8aa53";
    hash = "sha256-d1wTgIvnqWdlNnrwd5dw9Xy+6PVvyMOTV8AHEDdJAmc=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [
    cmake
    pkg-config
  ];

  makefile = "Makefile";

  # https://github.com/libretro/tic-80/blob/14fd99edc29962778bc88d81773288ffc6e8aa53/.gitlab-ci.yml#L12-L38
  cmakeFlags = with lib.strings; [
    (cmakeBool "BUILD_LIBRETRO" true)
    (cmakeBool "BUILD_DEMO_CARTS" false)
    (cmakeBool "BUILD_EDITORS" false)
    (cmakeBool "BUILD_PRO" false)
    (cmakeBool "BUILD_PLAYER" false)
    (cmakeBool "BUILD_SDL" false)
    (cmakeBool "BUILD_SOKOL" false)
    (cmakeBool "BUILD_TOOLS" false)
    (cmakeBool "BUILD_TOUCH_INPUT" false)
    # Link the script languages into the core; otherwise they are built as
    # plugins the libretro core never loads, and running a cart segfaults
    (cmakeBool "BUILD_STATIC" true)
    (cmakeBool "BUILD_WITH_ALL" false)
    (cmakeBool "BUILD_WITH_LUA" true)
    (cmakeBool "BUILD_WITH_MOON" true)
    (cmakeBool "BUILD_WITH_FENNEL" true)
    (cmakeBool "BUILD_WITH_WREN" true)
    (cmakeBool "BUILD_WITH_WASM" true)
    (cmakeBool "BUILD_WITH_SQUIRREL" true)
    (cmakeBool "BUILD_WITH_PYTHON" true)
    (cmakeBool "BUILD_WITH_JS" true)
    (cmakeBool "BUILD_WITH_JANET" false)
    (cmakeBool "BUILD_WITH_RUBY" false)
    (cmakeBool "BUILD_WITH_YUE" false)
    (cmakeBool "BUILD_WITH_SCHEME" false)
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

  postBuild = "cd bin";

  meta = {
    description = "Port of TIC-80 to libretro";
    homepage = "https://github.com/libretro/tic-80";
    license = lib.licenses.mit;
  };
}
