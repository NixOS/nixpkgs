{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-supafaust";
  version = "0-unstable-2024-10-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "supafaust";
    rev = "e25f66765938d33f9ad5850e8d6cd597e55b7299";
    hash = "sha256-ZgOXHhEHt54J2B1q6uA8v6uOK53g7idJlgoC4guTGow=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's experimental snes_faust core to libretro";
    homepage = "https://github.com/libretro/supafaust";
    license = lib.licenses.gpl2Only;
  };
}
