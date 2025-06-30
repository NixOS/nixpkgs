{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-06-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "3eece7a5447fde5ddf12be11bb5cb421d8fd8f97";
    hash = "sha256-NpCbeHcziBMw5IQ/8hD9cYq9zIAMd4H0OCpK8TydieA=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
