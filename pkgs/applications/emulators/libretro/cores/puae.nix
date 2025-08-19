{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-07-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "3fc66ee4b562910a17e2e2f3bad74572a8bcc134";
    hash = "sha256-rCdrM4511Q0OFwCsHZpYtg/4J1A4hwDc5WjwY0HDj8k=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
