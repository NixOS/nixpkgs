{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bluemsx";
  version = "0-unstable-2026-05-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bluemsx-libretro";
    rev = "175438e5fe68ae0cfb7d04c29f81eed17635e6b4";
    hash = "sha256-crFrG6OsmW3nNnQ+OHFtYz7cRuU9hTjWe3vq4PdYJqA=";
  };

  meta = {
    description = "Port of BlueMSX to libretro";
    homepage = "https://github.com/libretro/blueMSX-libretro";
    license = lib.licenses.gpl2Only;
  };
}
