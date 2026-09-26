{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  withBlarggAPU ? false,
}:
mkLibretroCore {
  core = "snes9x2005" + lib.optionalString withBlarggAPU "-plus";
  version = "0-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2005";
    rev = "deb49d80d1836e3e737480a326e31a54c46c04ae";
    hash = "sha256-UMW+YTzcSZ5CWSyRBYc8y1cDh/CU3Am11rkjSXlyxZA=";
  };

  makefile = "Makefile";
  makeFlags = lib.optionals withBlarggAPU [ "USE_BLARGG_APU=1" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.43 to Libretro";
    homepage = "https://github.com/libretro/snes9x2005";
    license = lib.licenses.unfreeRedistributable;
  };
}
