{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "atari800";
  version = "0-unstable-2026-01-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-atari800";
    rev = "d1d0d425458e6b5a2e51ad5f1507bdf97e857c95";
    hash = "sha256-gu1S4pNVq0MCK/77oGI6ekP1Nten72R6Y1n64oK/IFc=";
  };

  makefile = "Makefile";
  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Port of Atari800 to libretro";
    homepage = "https://github.com/libretro/libretro-atari800";
    license = lib.licenses.gpl2Only;
  };
}
