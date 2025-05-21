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
  version = "0-unstable-2025-03-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "ps2";
    rev = "6cc162de2162a0ffe92a4e0470141b9c7c095bf3";
    hash = "sha256-hzM4nt7Cp7l2fLtG60YmqVchuFskqVDyaZPHIO0E6Ws=";
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
