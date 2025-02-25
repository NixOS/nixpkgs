{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "2048";
  version = "0-unstable-2024-12-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-2048";
    rev = "86e02d3c2dd76858db7370f5df1ccfc33b3abee1";
    hash = "sha256-k3te3XZCw86NkqXpjZaYWi4twUvh9UBkiPyqposLTEs=";
  };

  meta = {
    description = "Port of 2048 puzzle game to libretro";
    homepage = "https://github.com/libretro/libretro-2048";
    license = lib.licenses.unlicense;
  };
}
