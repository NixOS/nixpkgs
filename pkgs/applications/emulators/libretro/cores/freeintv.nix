{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "freeintv";
  version = "0-unstable-2025-11-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "freeintv";
    rev = "1b51f41238ef9691d9fe16722f7d093bb6a6e379";
    hash = "sha256-kuznjK9HnqR42Cuz6bmUhEUnerrWb5VIvkiU0p//ecw=";
  };

  makefile = "Makefile";

  meta = {
    description = "FreeIntv libretro port";
    homepage = "https://github.com/libretro/freeintv";
    license = lib.licenses.gpl3Only;
  };
}
