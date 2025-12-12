{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-12-03";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "cc938d2194290ce25c8fbd149a864705887b1692";
    hash = "sha256-v4l7fgXvReMsqB7fbAzkY2vIfTGnMvSbeb8dPaK/KnA=";
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
