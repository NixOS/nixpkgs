{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
  libpcap,
  libGLU,
  libGL,
  libx11,
}:
mkLibretroCore {
  core = "desmume2015";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "desmume2015";
    rev = "f43dd42aae0816fcc69b2ebaa9299cbfef2ce2cc";
    hash = "sha256-jozi1aFgrvlBJ2cc+gXRHi1TguzSTz+GC4C3UNMl1D4=";
  };

  extraBuildInputs = [
    libpcap
    libGLU
    libGL
    libx11
  ];

  makeFlags =
    lib.optional stdenv.hostPlatform.isAarch32 "platform=armv-unix"
    ++ lib.optional (!stdenv.hostPlatform.isx86) "DESMUME_JIT=0";

  preBuild = "cd desmume";

  meta = {
    description = "Port of DeSmuME ~2015 to libretro";
    homepage = "https://github.com/libretro/desmume2015";
    license = lib.licenses.gpl2Plus;
  };
}
