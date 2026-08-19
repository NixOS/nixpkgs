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
  version = "0-unstable-2026-07-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "desmume2015";
    rev = "1cc4f73f85cdf33be8338edb4ac519e5e66abc3b";
    hash = "sha256-1dYVeNwBMHfa3BTv0vCV6n3TQvDEzQ76N9DTXLuJPmc=";
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
