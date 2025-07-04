{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bluemsx";
  version = "0-unstable-2025-04-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bluemsx-libretro";
    rev = "efaaa1052dc427d64534531cf59a6a9a659dc6a6";
    hash = "sha256-oCjIQ78YU5SeeefHHwd7l3U+YhwVMf6R2mbsuHAQUYQ=";
  };

  meta = {
    description = "Port of BlueMSX to libretro";
    homepage = "https://github.com/libretro/blueMSX-libretro";
    license = lib.licenses.gpl2Only;
  };
}
