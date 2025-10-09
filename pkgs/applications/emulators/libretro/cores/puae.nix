{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-08-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "9e2aa770a9b6b0a4e1f4fc05eb0db6c8e7aba8ee";
    hash = "sha256-YTS0OgYJCGawpsDHvU79dDA+iePna5Fcab2Le3vdVSk=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
