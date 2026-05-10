{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2026-05-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "d9cba8a41b3407ebb929816a7033e0407fd7b2d0";
    hash = "sha256-OdJStJK823PayWS+bmwG+kDrdx6KeVWYiSAu61C9UFs=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
