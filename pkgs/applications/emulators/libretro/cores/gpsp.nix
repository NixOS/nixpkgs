{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2025-11-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "6250979f01db3f9ee5ebca179316e1319f017b48";
    hash = "sha256-PSQiRh/8enFGCYs2AE5SwvZZzJfjMDarw3XW/x0A9qQ=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
