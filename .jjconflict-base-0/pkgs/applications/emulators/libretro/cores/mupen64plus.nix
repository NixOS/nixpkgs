{
  lib,
  stdenv,
  fetchFromGitHub,
  libGL,
  libGLU,
  libpng,
  mkLibretroCore,
  nasm,
  xorg,
}:
mkLibretroCore {
  core = "mupen64plus-next";
  version = "0-unstable-2024-10-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mupen64plus-libretro-nx";
    rev = "4249e39b2c200e5f0895385f76d99928785f2bea";
    hash = "sha256-nII/PMYo2xLznmAcKs6jDWGRS1DC3tiDeT6KJKRnaCI=";
  };

  extraBuildInputs = [
    libGLU
    libGL
    libpng
    nasm
    xorg.libX11
  ];
  makefile = "Makefile";
  makeFlags = [
    "HAVE_PARALLEL_RDP=1"
    "HAVE_PARALLEL_RSP=1"
    "HAVE_THR_AL=1"
    "LLE=1"
    "WITH_DYNAREC=${stdenv.hostPlatform.parsed.cpu.name}"
  ];

  meta = {
    description = "Libretro port of Mupen64 Plus";
    homepage = "https://github.com/libretro/mupen64plus-libretro-nx";
    license = lib.licenses.gpl3Only;
  };
}
