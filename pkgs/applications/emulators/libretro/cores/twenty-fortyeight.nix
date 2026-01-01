{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "2048";
<<<<<<< HEAD
  version = "0-unstable-2025-12-13";
=======
  version = "0-unstable-2024-12-27";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-2048";
<<<<<<< HEAD
    rev = "e70c3f82d2b861c64943aaff7fcc29a63013997d";
    hash = "sha256-ZNJUaXIQi9VnmmCikhCtXfhbTZ7rfJ1wm/582gaZCmk=";
=======
    rev = "86e02d3c2dd76858db7370f5df1ccfc33b3abee1";
    hash = "sha256-k3te3XZCw86NkqXpjZaYWi4twUvh9UBkiPyqposLTEs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Port of 2048 puzzle game to libretro";
    homepage = "https://github.com/libretro/libretro-2048";
    license = lib.licenses.unlicense;
  };
}
