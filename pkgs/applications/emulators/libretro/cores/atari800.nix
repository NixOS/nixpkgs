{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "atari800";
<<<<<<< HEAD
  version = "0-unstable-2025-12-04";
=======
  version = "0-unstable-2024-10-31";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-atari800";
<<<<<<< HEAD
    rev = "630f2346a1dabefdcf534880a48e3e200e2cc551";
    hash = "sha256-mCno2DHQXCJO2gStyp1te2XEUlrbX2iW3xIUOvZdoB0=";
=======
    rev = "6a18cb23cc4a7cecabd9b16143d2d7332ae8d44b";
    hash = "sha256-+cZXHtaXnpU/zCwiDtjkyNMFGDahiHzqV2FoTCRnUWE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  makefile = "Makefile";
  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Port of Atari800 to libretro";
    homepage = "https://github.com/libretro/libretro-atari800";
    license = lib.licenses.gpl2Only;
  };
}
