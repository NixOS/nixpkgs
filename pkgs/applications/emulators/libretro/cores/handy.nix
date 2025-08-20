{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "handy";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-handy";
    rev = "4e9e072796e5552a9d57f6ab83b3f85f27b17fb6";
    hash = "sha256-ThzFEqLCX2JC06n6GZgkGzX5sFY5CxFDjkeekXRmbXY=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Handy to libretro";
    homepage = "https://github.com/libretro/libretro-handy";
    license = lib.licenses.zlib;
  };
}
