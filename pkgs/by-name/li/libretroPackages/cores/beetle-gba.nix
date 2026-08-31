{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-gba";
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-gba-libretro";
    rev = "bb9edd1d611f245cd5aeb0b39986f2ecf6ec843f";
    hash = "sha256-E8DTXn+1ar7LwLwLUZqonmaYieX3BGfhjgxGFOz8F44=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's GameBoy Advance core to libretro";
    homepage = "https://github.com/libretro/beetle-gba-libretro";
    license = lib.licenses.gpl2Only;
  };
}
