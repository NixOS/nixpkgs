{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-lynx";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-lynx-libretro";
    rev = "40226b7b4fdd2604aa817fb7ded895b665282e25";
    hash = "sha256-HjqNFfx4e1+DPq05Ii3scNocMn2FLA/LcI1vfT3TUes=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's Lynx core to libretro";
    homepage = "https://github.com/libretro/beetle-lynx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
