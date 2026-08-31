{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "px68k";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "px68k-libretro";
    rev = "45dfd4005434d1199b01fb74a5371ec9bc513164";
    hash = "sha256-LA+m+BROJ1bm2v9YgLkEmfLYW0gF9/jOu/Sr7kze8gY=";
  };

  makefile = "Makefile";

  meta = {
    description = "Portable SHARP X68000 Emulator for Libretro";
    homepage = "https://github.com/libretro/px68k-libretro";
    license = lib.licenses.gpl2Only;
  };
}
