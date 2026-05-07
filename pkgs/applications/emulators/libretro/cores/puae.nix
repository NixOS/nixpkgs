{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-05-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "20e019d4405e33472a3c20824c53bcd79f474a1b";
    hash = "sha256-4yQtwE7Ghm2/43u2Xcht4WctTNkQjAhMTZtXj4EoJTA=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
