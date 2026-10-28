{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-10-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "7387937066b1b693816c3b4e2b7a0c601d41363d";
    hash = "sha256-cU8J5/av8H7cGKmIx09w1yHPGkX01CEF9CNBWFCn6wI=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
