{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-11-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "d366f77c60e5a5f059f129cc3773d3048306083b";
    hash = "sha256-jK39P8l927rEdSsLoYmKjhCRvUBXdj0vGKgWTW8xbCc=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
