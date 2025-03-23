{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  withBlarggAPU ? false,
}:
mkLibretroCore {
  core = "snes9x2005" + lib.optionalString withBlarggAPU "-plus";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2005";
    rev = "74d871db9b4dba6dbe6c5ecebc88cbf255be5349";
    hash = "sha256-YlRMjSEo9sdLVRzWGSJlnBeqg6wUhZi8l3ffzUaKQIQ=";
  };

  makefile = "Makefile";
  makeFlags = lib.optionals withBlarggAPU [ "USE_BLARGG_APU=1" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.43 to Libretro";
    homepage = "https://github.com/libretro/snes9x2005";
    license = lib.licenses.unfreeRedistributable;
  };
}
