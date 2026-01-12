{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "handy";
  version = "0-unstable-2025-06-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-handy";
    rev = "fca239207e9c111da3e85d2faf0b1b9d7524e498";
    hash = "sha256-8RpRhGgW5JWY6TZa9CEaXF66WpbjcjprorVqu+FGYu0=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Handy to libretro";
    homepage = "https://github.com/libretro/libretro-handy";
    license = lib.licenses.zlib;
  };
}
