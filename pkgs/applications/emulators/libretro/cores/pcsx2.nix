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
  version = "0-unstable-2026-01-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "ps2";
    rev = "c250dd849177f5903b4407e11212c8040ae64985";
    hash = "sha256-k7W5zRLLwoOJgnJa9a0PcpAQ+p7HtrEcA0NKjwDNg20=";
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
