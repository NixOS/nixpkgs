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
  version = "0-unstable-2025-08-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "ps2";
    rev = "c26b06ac2752a11ee47abc6f9c73595ee874341c";
    hash = "sha256-c7y1jCRQd/o4RTrOeqltcH8HOwrb+BLtaw//0ZWW4E0=";
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
