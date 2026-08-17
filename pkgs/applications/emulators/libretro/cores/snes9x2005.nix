{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  withBlarggAPU ? false,
}:
mkLibretroCore {
  core = "snes9x2005" + lib.optionalString withBlarggAPU "-plus";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2005";
    rev = "b60356971fc9caae02cd0853676dced886a08be7";
    hash = "sha256-6IuEFyJEoCHluSAXbk5qRTXku1XJCZ6p04BhdjqZqJQ=";
  };

  makefile = "Makefile";
  makeFlags = lib.optionals withBlarggAPU [ "USE_BLARGG_APU=1" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.43 to Libretro";
    homepage = "https://github.com/libretro/snes9x2005";
    license = lib.licenses.unfreeRedistributable;
  };
}
