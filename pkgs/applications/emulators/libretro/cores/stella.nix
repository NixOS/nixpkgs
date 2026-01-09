{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "6efad98f0058e803ac675ead6dbe33c054db1492";
    hash = "sha256-iwGDxd+xrxGgLZF9896OaYMMCo573l9lbnSZgNstHOQ=";
  };

  makefile = "Makefile";
  preBuild = "cd src/os/libretro";
  dontConfigure = true;

  meta = {
    description = "Port of Stella to libretro";
    homepage = "https://github.com/stella-emu/stella";
    license = lib.licenses.gpl2Only;
  };
}
