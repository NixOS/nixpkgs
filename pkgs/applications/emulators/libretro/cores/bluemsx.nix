{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bluemsx";
  version = "0-unstable-2026-04-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bluemsx-libretro";
    rev = "0b23b79f6b8c19f300d2d86958e89fbe2f6d30bc";
    hash = "sha256-/rILuViKZBKZFZkCjuFuuuOE3AvDiHQqHtWq4Q8XSMA=";
  };

  meta = {
    description = "Port of BlueMSX to libretro";
    homepage = "https://github.com/libretro/blueMSX-libretro";
    license = lib.licenses.gpl2Only;
  };
}
