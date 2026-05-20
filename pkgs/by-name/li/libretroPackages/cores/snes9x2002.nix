{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x2002";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2002";
    rev = "39e0d8c6daf4b1b1302eeecfee8309570aeb6a82";
    hash = "sha256-mOtCZEuXKWQEupWfFfr3Ji6m15zZuOIJ/ieKtrFGsWI=";
  };

  makefile = "Makefile";

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.39 to Libretro";
    homepage = "https://github.com/libretro/snes9x2002";
    license = lib.licenses.unfreeRedistributable;
  };
}
