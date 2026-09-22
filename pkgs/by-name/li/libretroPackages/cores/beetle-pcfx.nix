{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pcfx";
  version = "0-unstable-2026-09-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pcfx-libretro";
    rev = "c1650bad5fbdcc3c3ccd45e29e3983e1ccf16cff";
    hash = "sha256-gqippUOmzEkfxFf0PorK6FdyXvcXhkIhGderR7wBNWQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PCFX core to libretro";
    homepage = "https://github.com/libretro/beetle-pcfx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
