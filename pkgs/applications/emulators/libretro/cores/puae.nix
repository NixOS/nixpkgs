{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-04-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "7dd724eaa48f05f02d9d2f1bfa131c34b6ab5351";
    hash = "sha256-i046+gZa8u/nmGGlF/uA2Lz5VZJTgwXz9aK2C/2l470=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
