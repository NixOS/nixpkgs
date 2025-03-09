{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "atari800";
  version = "0-unstable-2024-10-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-atari800";
    rev = "6a18cb23cc4a7cecabd9b16143d2d7332ae8d44b";
    hash = "sha256-+cZXHtaXnpU/zCwiDtjkyNMFGDahiHzqV2FoTCRnUWE=";
  };

  makefile = "Makefile";
  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Port of Atari800 to libretro";
    homepage = "https://github.com/libretro/libretro-atari800";
    license = lib.licenses.gpl2Only;
  };
}
