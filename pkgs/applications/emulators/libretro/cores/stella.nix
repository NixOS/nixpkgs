{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-02-16";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "dccefede9b9e0c1f08cb645ac4c1b922579b93fa";
    hash = "sha256-J9/6plYOa44ZeVWilJWSR5ZQF0bzZ8w5v272iIAOMxM=";
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
