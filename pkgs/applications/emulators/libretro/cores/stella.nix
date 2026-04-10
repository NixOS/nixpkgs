{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-04-04";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "1a09c51e639d44bd821a598a095c5d3f6776590e";
    hash = "sha256-qEEE7QMTDwVFMB/6dmTq8VsOQ9qwYky8SBGD0KppqTs=";
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
