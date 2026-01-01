{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bsnes";
<<<<<<< HEAD
  version = "0-unstable-2025-12-19";
=======
  version = "0-unstable-2025-11-14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bsnes-libretro";
<<<<<<< HEAD
    rev = "d9b7c292cfb15959c9928e3b76bb1047b8499938";
    hash = "sha256-FzYe6p3+knxcoIcQW00p3C3+rMEsAWI+ZFdy5mvDhoY=";
=======
    rev = "c11dd1f8551ad9b6668ebfcbb5833cfc034b7205";
    hash = "sha256-8QI7/BaAm3GERPUUprzFTrH7CuPK7W0fCAoHEefKeaI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  makefile = "Makefile";

  meta = {
    description = "Port of bsnes to libretro";
    homepage = "https://github.com/libretro/bsnes-libretro";
    license = lib.licenses.gpl3Only;
  };
}
