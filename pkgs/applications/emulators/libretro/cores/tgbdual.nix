{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "tgbdual";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "tgbdual-libretro";
    rev = "8d305769eebd67266c284558f9d3a30498894d3d";
    hash = "sha256-3mlnTgp43qC3yifpr6pvtC4vslddcf6mephKA183vEk=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of TGBDual to libretro";
    homepage = "https://github.com/libretro/tgbdual-libretro";
    license = lib.licenses.gpl2Only;
  };
}
