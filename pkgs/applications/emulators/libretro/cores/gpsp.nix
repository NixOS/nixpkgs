{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2025-10-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "74db5e5c73020626a1118b97d3735b5636d65d9d";
    hash = "sha256-/tu+g0VDcRIycqxB4TQmDROtrp2PBNKoR4fzdajGeIM=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
