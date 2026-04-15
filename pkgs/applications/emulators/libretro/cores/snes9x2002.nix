{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x2002";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2002";
    rev = "15826a2afc1474b30c310502b5dbe25c639be59d";
    hash = "sha256-LVTtpnmZzmKCohFwc74qLMR6cN4ntT/o/OUQOg6mdU0=";
  };

  makefile = "Makefile";

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.39 to Libretro";
    homepage = "https://github.com/libretro/snes9x2002";
    license = lib.licenses.unfreeRedistributable;
  };
}
