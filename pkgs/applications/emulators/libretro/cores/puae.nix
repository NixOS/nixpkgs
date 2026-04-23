{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-02-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "bea8c084beaf576f54dc1be42d715d424265cda2";
    hash = "sha256-CU/BVXys7VBra4qaMBjTgKQP1hke7+wqJ2RMYUXIXlo=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
