{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-07-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "c59492b07f7c586064692110e8138c83ed8bc7c7";
    hash = "sha256-ijcajte446DSjD2vJ7PNdD6Zr9Wj39kEw844g1VARJw=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
