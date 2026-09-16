{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "o2em";
  version = "0-unstable-2026-07-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-o2em";
    rev = "679d6fec04963f6e70a7ec217e3d0ebb1fe472fc";
    hash = "sha256-s09Enxt3ziiAITNWk6FVgOblE2T2t1UjyI2TFbl3LtQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of O2EM to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.artistic1;
  };
}
