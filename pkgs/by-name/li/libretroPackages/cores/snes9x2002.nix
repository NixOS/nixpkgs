{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x2002";
  version = "0-unstable-2026-09-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2002";
    rev = "24b34890cfc17e7113d8d2235848371c0cd96f50";
    hash = "sha256-wISkfIUgnyMk0veXUgPhWiaDNMsPpb+MHY/v3SjZwmY=";
  };

  makefile = "Makefile";

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.39 to Libretro";
    homepage = "https://github.com/libretro/snes9x2002";
    license = lib.licenses.unfreeRedistributable;
  };
}
