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
  version = "0-unstable-2026-05-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "desmume";
    rev = "a55c393de8ecf19df8111f65b8e12d08b9616520";
    hash = "sha256-0+uSOg1asszgnDbdRsfWQY/E2Ky2tK3KxkcNV2mGjBQ=";
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
