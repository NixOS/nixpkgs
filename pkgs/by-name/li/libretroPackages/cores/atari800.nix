{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "atari800";
  version = "0-unstable-2026-08-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-atari800";
    rev = "cd721790a0aa0e0772810949abcf5bd699c15371";
    hash = "sha256-aNAvnd1fTPuecCcTdLK8EJ6GjWdO3Dc5sLA8sRxqRAE=";
  };

  makefile = "Makefile";
  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Port of Atari800 to libretro";
    homepage = "https://github.com/libretro/libretro-atari800";
    license = lib.licenses.gpl2Only;
  };
}
