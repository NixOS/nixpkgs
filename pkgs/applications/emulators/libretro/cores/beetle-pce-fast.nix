{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pce-fast";
  version = "0-unstable-2026-08-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pce-fast-libretro";
    rev = "bebe2b13a840fbfd45cb501f5cd0efe01bdb1735";
    hash = "sha256-z30s5uYhqBht7ZviljAu5WZlOCTS9sYqWBD2/hbWUbs=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PC Engine fast core to libretro";
    homepage = "https://github.com/libretro/beetle-pce-fast-libretro";
    license = lib.licenses.gpl2Only;
  };
}
