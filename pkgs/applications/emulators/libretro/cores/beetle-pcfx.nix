{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pcfx";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pcfx-libretro";
    rev = "035191393485280cad1866ce3aedd626d4fa09d0";
    hash = "sha256-jchEbKvHSE4D90ezwi//nl8vefQD4gp6YWb0eb6zkeY=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PCFX core to libretro";
    homepage = "https://github.com/libretro/beetle-pcfx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
