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
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "desmume2015";
    rev = "422b688009ccb9f2917c086a8fe79c8cecb030ae";
    hash = "sha256-jkzUalzkrxNv3IfO3admuy5PwvOoMJ5RrJHE6T07oSE=";
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
