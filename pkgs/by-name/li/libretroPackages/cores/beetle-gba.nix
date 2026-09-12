{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-gba";
  version = "0-unstable-2026-09-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-gba-libretro";
    rev = "b158166237b17253188cfdbe73a8a0b9fe4b3a8c";
    hash = "sha256-0G1H3VdXtgj+cU2gT9F7135NFu+vyk3hthIjKBweDyQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's GameBoy Advance core to libretro";
    homepage = "https://github.com/libretro/beetle-gba-libretro";
    license = lib.licenses.gpl2Only;
  };
}
