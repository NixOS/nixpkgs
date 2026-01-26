{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "2048";
  version = "0-unstable-2025-12-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-2048";
    rev = "e70c3f82d2b861c64943aaff7fcc29a63013997d";
    hash = "sha256-ZNJUaXIQi9VnmmCikhCtXfhbTZ7rfJ1wm/582gaZCmk=";
  };

  meta = {
    description = "Port of 2048 puzzle game to libretro";
    homepage = "https://github.com/libretro/libretro-2048";
    license = lib.licenses.unlicense;
  };
}
