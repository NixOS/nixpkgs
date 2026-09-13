{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-09-10";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "c65c845c8686c81698ffbd2fc9dfc5ccea5b32a1";
    hash = "sha256-K1mHkL3kH8y/oGQoVGRwYXt5Xb/O3r+45+uvCYXyWpc=";
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
