{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-05-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "6fbf272e342387281484ae84f690fa129f0ab86e";
    hash = "sha256-JwFIQfWaorQmDxYgHvpq/CEFMc0LVAsX6TyiGN6FhZA=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
