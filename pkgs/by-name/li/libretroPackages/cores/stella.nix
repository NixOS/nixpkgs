{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "4569658d24abcbfe6450b49fccacdc48e6d96580";
    hash = "sha256-IFBtPZdVlUd3D4nwYt0nor8mC0Lhw+Uq/WUygxahC0k=";
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
