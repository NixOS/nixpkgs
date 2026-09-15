{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2026-09-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "6536174a80d74e6c325aaa5390ff091fac8761d0";
    hash = "sha256-jewi3fnEDyUsNxCBns4Gp+3JrWsd5xp2lHxT69caBiU=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
