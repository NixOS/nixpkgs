{
  lib,
  fetchFromGitHub,
  boost,
  ffmpeg_6,
  gcc12Stdenv,
  libGL,
  libGLU,
  mkLibretroCore,
  nasm,
}:
mkLibretroCore rec {
  core = "citra";
  version = "0-unstable-2024-04-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "citra";
    # TODO: upstream migrated to cmake, this is the latest rev without it
    rev = "36b600692905ebd457cbc9321e2f521938eced16";
    hash = "sha256-ZJcsdFgLBda4xS4Z6I8Pu+6B9TYwak//0CbloDK3Yg0=";
    fetchSubmodules = true;
  };

  makefile = "Makefile";
  makeFlags = [
    "HAVE_FFMPEG_STATIC=0"
    # https://github.com/libretro/citra/blob/1a66174355b5ed948de48ef13c0ed508b6d6169f/Makefile#L87-L90
    "GIT_REV=${src.rev}"
    "GIT_DESC=${lib.substring 0 7 src.rev}"
    "GIT_BRANCH=master"
    "BUILD_DATE=01/01/1970_00:00"
  ];

  extraBuildInputs = [
    boost
    ffmpeg_6
    libGL
    libGLU
    nasm
  ];

  # FIXME: build fail with GCC13:
  # error: 'mic_device_name' has incomplete type
  stdenv = gcc12Stdenv;

  meta = {
    description = "Port of Citra to libretro";
    homepage = "https://github.com/libretro/citra";
    license = lib.licenses.gpl2Plus;
  };
}
