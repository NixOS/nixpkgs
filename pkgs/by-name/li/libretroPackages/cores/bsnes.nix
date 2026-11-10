{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bsnes";
  version = "0-unstable-2026-09-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bsnes-libretro";
    rev = "05439f96121d2b9d7ad7a5fc1f29d7eebdcc8c43";
    hash = "sha256-ayvg/oBDr2atxRIQuMVcj2XKeQdJe8VeU7aZSqHwz5Q=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of bsnes to libretro";
    homepage = "https://github.com/libretro/bsnes-libretro";
    license = lib.licenses.gpl3Only;
  };
}
