{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-04-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "bd2ef50e22f5ded91cae347e98352f5bd2e7e6c2";
    hash = "sha256-/C483el8uS2ZhmRpsIXMa0kILxyMyLBqkkySJ78rj+A=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
