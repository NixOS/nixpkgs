{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-supafaust";
  version = "0-unstable-2026-07-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "supafaust";
    rev = "d6187e5337e6c2646d003db3ab1936727ca75301";
    hash = "sha256-r9sZGTpJo+jiEDZnzSgcwzBerI4BHL2p/WvJQpdW31g=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's experimental snes_faust core to libretro";
    homepage = "https://github.com/libretro/supafaust";
    license = lib.licenses.gpl2Only;
  };
}
