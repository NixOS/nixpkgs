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

  # CMake Error at 3rdparty/libzip/libzip/CMakeLists.txt:1 (cmake_minimum_required):
  # Compatibility with CMake < 3.5 has been removed from CMake.
  #
  # Update the VERSION argument <min> value.  Or, use the <min>...<max> syntax
  # to tell CMake that the project requires at least <min> but has been updated
  # to work with policies introduced by <max> or earlier.
  #
  # Or, add -DCMAKE_POLICY_VERSION_MINIMUM=3.5 to try configuring anyway.
  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  # libretro/ps2 needs at least those flags to compile, and probably doesn't
  # work on x86_64-v1
  # https://github.com/libretro/ps2/blob/397b8f54b92aeffd2dd502c2c9b601305fb1de9d/cmake/BuildParameters.cmake#L101
  env.NIX_CFLAGS_COMPILE = toString [
    "-msse"
    "-msse2"
    "-msse4.1"
    "-mfxsr"
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
