{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-03-02";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "b89c2fecb2a00449c484f47ff8437bce2db1b5b9";
    hash = "sha256-/cWHUlr9msupT6acfUub1Jr7LCPlasFD7ZCrS9kvCnI=";
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
