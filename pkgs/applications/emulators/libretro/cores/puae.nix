{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-01-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "9b05ecda81e14c0c5b2c5f6af8a65d034afd54a1";
    hash = "sha256-jBY+Xn9aR/lTyxFZlydWJA5+bpkaCcyCAiYG3fcmGmc=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
