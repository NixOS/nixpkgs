{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-08-31";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "8cf47460afc2732e9d4a17e72d1e4830e7a7fa6e";
    hash = "sha256-ppVJiiLf/GvdunIFRl4czqCr3/Rd+rpirRBjdVH38mk=";
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
