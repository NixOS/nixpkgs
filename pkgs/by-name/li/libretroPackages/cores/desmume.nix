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
  core = "desmume";
  version = "0-unstable-2026-09-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "desmume";
    rev = "95b4d798731caa809125b6c3c11d17cc332ff6ef";
    hash = "sha256-hewHELQM+snFUDEwhzOapZbhcv0oHv1s0QHjn/FpNWg=";
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

  preBuild = "cd desmume/src/frontend/libretro";

  meta = {
    description = "Port of DeSmuME to libretro";
    homepage = "https://github.com/libretro/desmume";
    license = lib.licenses.gpl2Plus;
  };
}
