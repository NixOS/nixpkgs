{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x2002";
  version = "0-unstable-2026-06-25";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2002";
    rev = "5bd8bd6d449be8a2ef7909e1aeb2bd8c9c0da8cb";
    hash = "sha256-iqhmSJzWqr5HgtY9q+kBb/xB6njvG3M2SePXdRszqqc=";
  };

  makefile = "Makefile";

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.39 to Libretro";
    homepage = "https://github.com/libretro/snes9x2002";
    license = lib.licenses.unfreeRedistributable;
  };
}
