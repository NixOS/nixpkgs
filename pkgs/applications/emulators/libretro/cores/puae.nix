{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-01-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "67785f95db6e96dc081a2207751ab98b06b422ab";
    hash = "sha256-jJ1yki9uPutIdAI6TBKPWjiZc7W5K9n7P/oYA/UWJf4=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
