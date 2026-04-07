{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fuse";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fuse-libretro";
    rev = "b5f44e3a20a0f189e8fb999cd5cde223a0f588a6";
    hash = "sha256-ZYk9qe+9yJmi+zsKT3IDvyiPCxivwghT68ku6WfaVa8=";
  };

  meta = {
    description = "Port of the Fuse Unix Spectrum Emulator to libretro";
    homepage = "https://github.com/libretro/fuse-libretro";
    license = lib.licenses.gpl3Only;
  };
}
