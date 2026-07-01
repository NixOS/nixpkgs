{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2026-06-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "8b34285807d4825a5ab34b67f0c9d0a780a955c8";
    hash = "sha256-VF9ScwineHNAd7Poj6/U5KEL6uUMhXLmR8nJS9vDSXk=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
