{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2024-10-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "c60e42ef9ad474518d4be859b7c1da2c0c7e1d6f";
    hash = "sha256-WCkz7BUgYaI+yRhPmNuOKGJC/GxV+n2aeJVn8vhx0Ng=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
