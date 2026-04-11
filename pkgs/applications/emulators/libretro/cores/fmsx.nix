{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fmsx";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fmsx-libretro";
    rev = "6b807c588d63677770f7f2ed8b94ca0e9da256ce";
    hash = "sha256-vA9ODUtmmrDPbZjmRJ9IIFELLTD8g8aHmQdo/B/d1fQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "FMSX libretro port";
    homepage = "https://github.com/libretro/fmsx-libretro";
    license = lib.licenses.unfreeRedistributable;
  };
}
