{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-04-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "e5b036f0be19f7a70fde75cc0e8b1b43476adc13";
    hash = "sha256-GzvsXPZcBfGvA0g7zLR3R7w5CEIw2slL3EyQdcDjqCc=";
  };

  makefile = "Makefile";

  env = {
    EMUTYPE = "${type}";
  };

  meta = {
    description = "Port of vice to libretro";
    homepage = "https://github.com/libretro/vice-libretro";
    license = lib.licenses.gpl2;
  };
}
