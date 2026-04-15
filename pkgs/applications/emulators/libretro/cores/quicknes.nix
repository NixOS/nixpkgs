{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "quicknes";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "QuickNES_Core";
    rev = "71782569078f29214017a966b0f992b9e512bf19";
    hash = "sha256-Bx1iZcrUG5B/wjeWf2hZEAIocM7dKgRwRPqpGzS2Cgc=";
  };

  makefile = "Makefile";

  meta = {
    description = "QuickNES libretro port";
    homepage = "https://github.com/libretro/QuickNES_Core";
    license = lib.licenses.lgpl21Plus;
  };
}
