{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nxengine";
  version = "0-unstable-2026-08-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nxengine-libretro";
    rev = "fd1c0686f8b4c0aea9b5addbc077e3ad7da23bb7";
    hash = "sha256-auignLadG47leMeN6XqIVzs1KEJ+LwLpHO/8ZC+46po=";
  };

  makefile = "Makefile";

  meta = {
    description = "NXEngine libretro port";
    homepage = "https://github.com/libretro/nxengine-libretro";
    license = lib.licenses.gpl3Only;
  };
}
