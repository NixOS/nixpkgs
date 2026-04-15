{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mesen";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mesen";
    rev = "4df4d3681e89321cd4e571ee5cacfdef91842566";
    hash = "sha256-f067kvu+Pp27iJiVAZczg49Qxz9DVPnGw/Hjwi6+a0Y=";
  };

  makefile = "Makefile";
  preBuild = "cd Libretro";

  meta = {
    description = "Port of Mesen to libretro";
    homepage = "https://github.com/libretro/mesen";
    license = lib.licenses.gpl3Only;
  };
}
