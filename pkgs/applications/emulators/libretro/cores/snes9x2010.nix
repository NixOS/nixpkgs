{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "da064275845dfa57e14eb0e5b5c7ddcc117e9f06";
    hash = "sha256-uNmgQjIVXMhVinkSZnH6P/Nm4ESPEYjURj5TEf4hoxY=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
