{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-05-21";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "3d3f223a17fe065c7dee1ff440f0309eb8583009";
    hash = "sha256-RR6/zRqFUctWc+Rrbm+4Twk6GZwpPgYHgFP65sL6UN8=";
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
