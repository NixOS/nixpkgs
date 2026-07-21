{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bluemsx";
  version = "0-unstable-2026-07-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bluemsx-libretro";
    rev = "2f31e9ca38785ad4c2bd9e1d91829eda14a92954";
    hash = "sha256-J1LbOsUR+9HX/LRtkG9XQIiRdhfyHUYvqXYBKWdGxBI=";
  };

  meta = {
    description = "Port of BlueMSX to libretro";
    homepage = "https://github.com/libretro/blueMSX-libretro";
    license = lib.licenses.gpl2Only;
  };
}
