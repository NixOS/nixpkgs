{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fuse";
  version = "0-unstable-2024-09-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fuse-libretro";
    rev = "6fd07d90acc38a1b8835bf16539b833f21aaa38f";
    hash = "sha256-q5vcFNr1RBeTaw1R2LDY9xLU1oGeWtPemTdliWR+39s=";
  };

  meta = {
    description = "Port of the Fuse Unix Spectrum Emulator to libretro";
    homepage = "https://github.com/libretro/fuse-libretro";
    license = lib.licenses.gpl3Only;
  };
}
