{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "virtualjaguar";
  version = "0-unstable-2026-05-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "virtualjaguar-libretro";
    rev = "18828045f76a803206ebffc9b8d57842287b7552";
    hash = "sha256-lHQsApSoZNvyTp6D3lOBHyLCQ321cirUVXZRHXvIdP4=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of VirtualJaguar to libretro";
    homepage = "https://github.com/libretro/virtualjaguar-libretro";
    license = lib.licenses.gpl3Only;
  };
}
