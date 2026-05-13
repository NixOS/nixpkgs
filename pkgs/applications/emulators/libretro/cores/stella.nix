{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-04-28";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "0c1b944387b5ac2b1bf753c2c4221db4fdc10f79";
    hash = "sha256-mohkp6oOP8MtRs/WHw4Rxs3FrB6h4X6/ENrRdjiiXlQ=";
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
