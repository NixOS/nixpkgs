{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bsnes";
  version = "0-unstable-2025-09-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bsnes-libretro";
    rev = "aeb76d7dc33c1f136db43d65ba9622c14e81b0fa";
    hash = "sha256-DpCG+DyeSCMdAF+TGB6zSRp/fttoyw9eCXy8PLvRjaY=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of bsnes to libretro";
    homepage = "https://github.com/libretro/bsnes-libretro";
    license = lib.licenses.gpl3Only;
  };
}
