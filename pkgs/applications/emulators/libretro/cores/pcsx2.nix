{
  lib,
  cmake,
  fetchFromGitHub,
  libGL,
  libGLU,
  mkLibretroCore,
  perl,
  pkg-config,
  xz,
}:
mkLibretroCore {
  core = "pcsx2";
  version = "0-unstable-2025-09-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "ps2";
    rev = "9485a53fa5aa2bff17e04518116107f81a8c82e3";
    hash = "sha256-xkRPESbLNX9AFOIdEA9iW4Xn7hdJXfdi+TEbegC8KXA=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [
    cmake
    pkg-config
  ];

  extraBuildInputs = [
    libGL
    libGLU
    perl
    xz
  ];

  cmakeFlags = with lib.strings; [
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
    # Explicitly set ARCH_FLAG to avoid -march=native
    # https://github.com/libretro/ps2/blob/9485a53fa5aa2bff17e04518116107f81a8c82e3/cmake/BuildParameters.cmake#L106-L117
    (cmakeFeature "ARCH_FLAG" "-msse4.1")
  ];

  makefile = "Makefile";

  preInstall = "cd bin";

  meta = {
    description = "Port of PCSX2 to libretro";
    homepage = "https://github.com/libretro/ps2";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.x86;
  };
}
