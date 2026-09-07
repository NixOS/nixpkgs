{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "bc0c2b0ec64b81e368fa253f029e31247aeb66ac";
    hash = "sha256-ExD4yQGc962HacOyok7L47KkpX3FjbXSjELOX6ti//g=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
