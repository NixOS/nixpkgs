{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-07-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "96ebfcfc2c66233ad37f6dc99ee991211dc719ad";
    hash = "sha256-bqqb1gSg4Y0TjB/oQmUBRK8ZeX7hHuVfbH6XfHv25yY=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
