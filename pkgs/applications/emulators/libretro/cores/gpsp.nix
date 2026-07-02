{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "d6decfa351b575e2936afebba26d41ec20e4ddcd";
    hash = "sha256-kqqNyBEaWlj9E4tZz7VK2186Y6DRDtcFBMIH7GpUDx4=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
