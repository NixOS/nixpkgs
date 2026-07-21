{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "2048";
  version = "0-unstable-2026-04-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-2048";
    rev = "c90437d3c3913999624deca3fb55ecfa632b72c4";
    hash = "sha256-dE3PanK+rpf01R4aoD3KMwVhEVvmmVS2klVPQUGTUC0=";
  };

  meta = {
    description = "Port of 2048 puzzle game to libretro";
    homepage = "https://github.com/libretro/libretro-2048";
    license = lib.licenses.unlicense;
  };
}
