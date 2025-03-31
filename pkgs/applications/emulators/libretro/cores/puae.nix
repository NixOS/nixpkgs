{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-03-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "987ac9bf14b813bf14ee6ab0f9d1f95c9d19ea78";
    hash = "sha256-ONL7KjDMF+syiwBG+ivU7b7D7qFVr2gpw5ulnV3OZU8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
