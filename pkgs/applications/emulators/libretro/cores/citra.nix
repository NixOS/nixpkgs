{
  lib,
  cmake,
  fetchFromGitHub,
  libGL,
  libGLU,
  libX11,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "citra";
  version = "0-unstable-2025-08-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "citra";
    rev = "5263fae3344e5e9af43036e0e38bec2d10fb2407";
    hash = "sha256-66kbE1taODjxXDhO3uV5R212nikyXfHwCHC/zamZuL0=";
    fetchSubmodules = true;
  };

  makefile = "Makefile";

  extraBuildInputs = [
    libGL
    libGLU
    libX11
  ];

  extraNativeBuildInputs = [ cmake ];

  # https://github.com/libretro/citra/blob/a31aff7e1a3a66f525b9ea61633d2c5e5b0c8b31/.gitlab-ci.yml#L6
  cmakeFlags = with lib.strings; [
    (cmakeBool "ENABLE_TESTS" false)
    (cmakeBool "ENABLE_DEDICATED_ROOM" false)
    (cmakeBool "ENABLE_SDL2" false)
    (cmakeBool "ENABLE_QT" false)
    (cmakeBool "ENABLE_WEB_SERVICE" false)
    (cmakeBool "ENABLE_SCRIPTING" false)
    (cmakeBool "ENABLE_OPENAL" false)
    (cmakeBool "ENABLE_LIBUSB" false)
    (cmakeBool "CITRA_ENABLE_BUNDLE_TARGET" false)
    (cmakeBool "CITRA_WARNINGS_AS_ERRORS" false)
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

  meta = {
    description = "Port of Citra to libretro";
    homepage = "https://github.com/libretro/citra";
    license = lib.licenses.gpl2Plus;
  };
}
