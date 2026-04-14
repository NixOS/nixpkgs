{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gw";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gw-libretro";
    rev = "f8750d0f37db5f1f779437710f2653e8b1651ded";
    hash = "sha256-nhCklogKXqjIsRFFKPk6SoIA+K7oCl+15dWdtvvcznE=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Game and Watch to libretro";
    homepage = "https://github.com/libretro/gw-libretro";
    license = lib.licenses.zlib;
  };
}
