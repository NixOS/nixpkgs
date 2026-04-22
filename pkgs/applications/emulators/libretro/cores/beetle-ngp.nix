{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-ngp";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-ngp-libretro";
    rev = "9abe025fa14a4835a9a4e14a09893520dd3019dc";
    hash = "sha256-s/4koTwwgeEUYknpaNruY1l03ZGYSUy8KVxD/hiGs8Q=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's NeoGeo Pocket core to libretro";
    homepage = "https://github.com/libretro/beetle-ngp-libretro";
    license = lib.licenses.gpl2Only;
  };
}
