{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-gba";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-gba-libretro";
    rev = "6cee80685f735ea6c2373db2622a1f1ee9f39d39";
    hash = "sha256-a3XgExXVCUFw3GLCUkEl6now2L8qVdNOaXvrDMcT1ZE=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's GameBoy Advance core to libretro";
    homepage = "https://github.com/libretro/beetle-gba-libretro";
    license = lib.licenses.gpl2Only;
  };
}
