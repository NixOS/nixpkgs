{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-gba";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-gba-libretro";
    rev = "145d4884ad246e3c16765f6d69decb2a4359b6ae";
    hash = "sha256-4LRMPsPrYvdTJGcbbS3ZyimrWKxZSU+bP0SxUMLkYgE=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's GameBoy Advance core to libretro";
    homepage = "https://github.com/libretro/beetle-gba-libretro";
    license = lib.licenses.gpl2Only;
  };
}
