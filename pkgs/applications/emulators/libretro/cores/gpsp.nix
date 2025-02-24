{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2025-01-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "b0d5d27ae51c23f514974ddffa5760f1e1d05d9b";
    hash = "sha256-e2U1xEshoPJlaVUEbqNZIayNaSdDC65hE1VrvxvQSx0=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
