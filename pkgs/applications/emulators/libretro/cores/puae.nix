{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-02-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "12972a7da5aeb849ba7234dff342625d23617eaf";
    hash = "sha256-/w1Rbw0eStWyoR+UDD7a298vVAa0vb67qUPfiqhfm/k=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
