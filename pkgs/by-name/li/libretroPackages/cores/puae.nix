{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-10-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "e2e31c73368c0b9be814a6e6ff09751aa8fb494e";
    hash = "sha256-0m4xBr7eG8oSQ5uIhuYIyTnbNkbxdIbzHVuxJvecBzQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
