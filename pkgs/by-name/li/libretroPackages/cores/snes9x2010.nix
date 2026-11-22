{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "snes9x2010";
  version = "0-unstable-2026-11-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2010";
    rev = "82904a95e9bab2c3e63395e4b9ece8fdca8b785d";
    hash = "sha256-UqN5uH22kvhPVByacyBxm00n7m+sc0VZHcHDWT5gRuU=";
  };

  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
    homepage = "https://github.com/libretro/snes9x2010";
    license = lib.licenses.unfreeRedistributable;
  };
}
