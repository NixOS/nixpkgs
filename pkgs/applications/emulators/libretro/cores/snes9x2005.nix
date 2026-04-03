{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  withBlarggAPU ? false,
}:
mkLibretroCore {
  core = "snes9x2005" + lib.optionalString withBlarggAPU "-plus";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2005";
    rev = "10519b751ebc800accf4f95cf767e5533d96c97a";
    hash = "sha256-vMkLEEvuYBCtgWZ2ZxWKLeqFDeLoP1CYa68I8Qg2Dx4=";
  };

  makefile = "Makefile";
  makeFlags = lib.optionals withBlarggAPU [ "USE_BLARGG_APU=1" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.43 to Libretro";
    homepage = "https://github.com/libretro/snes9x2005";
    license = lib.licenses.unfreeRedistributable;
  };
}
