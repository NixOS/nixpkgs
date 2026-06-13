{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2026-06-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "2db57b11a437c4432ab69823bdcd951181de6213";
    hash = "sha256-oiq79/wGja8ZMOrjgeDid1hYxVkG2YfKe9h+Dkq48kY=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
