{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "o2em";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-o2em";
    rev = "dee1076eb70c728d4ff47186aea9cd1c11ce7638";
    hash = "sha256-djj7sEkUIoze1sZaZciIw7PdYDb1wETuZd4CFdZTiUM=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of O2EM to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.artistic1;
  };
}
