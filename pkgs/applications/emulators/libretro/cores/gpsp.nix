{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2024-09-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "36061caf8cc5e15c3c92fb772b6b8560c7c59ec7";
    hash = "sha256-o36OUdgm7p+rAMN6R2e2Lqi4oBLTyxziw7Lr20ERBg0=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
