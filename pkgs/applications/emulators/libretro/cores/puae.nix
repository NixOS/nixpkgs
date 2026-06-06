{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-06-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "2b0ed42fe565fb997a0627aaa8f44e0948b527f8";
    hash = "sha256-gkCzHvoSqh9CluahSSe3+dhZG1HtiNH0orU404pwjgo=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
