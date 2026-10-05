{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x2002";
  version = "0-unstable-2026-09-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "snes9x2002";
    rev = "6ffbf9ef4f0063e1f1b78a40d10c50fc52f2524c";
    hash = "sha256-n+d98dLgfaGZ3XT7as/H5n8Qs5StfafYzH9BDKbw49M=";
  };

  makefile = "Makefile";

  meta = {
    description = "Optimized port/rewrite of SNES9x 1.39 to Libretro";
    homepage = "https://github.com/libretro/snes9x2002";
    license = lib.licenses.unfreeRedistributable;
  };
}
