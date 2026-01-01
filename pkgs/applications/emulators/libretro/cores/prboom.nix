{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prboom";
<<<<<<< HEAD
  version = "0-unstable-2025-12-13";
=======
  version = "0-unstable-2024-12-27";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-prboom";
<<<<<<< HEAD
    rev = "93c8e7a2074e4fd8410398e3d571c6d9afec1d84";
    hash = "sha256-O1C6CJ0MM21I69AtoAMx7ZX4U041hNrMXx22fEgshRI=";
=======
    rev = "b3e5f8b2e8855f9c6fc7ff7a0036e4e61379177d";
    hash = "sha256-FtPn54s/QUu8fjeUBaAQMZ6EWAixV+gawuCv2eM+qrs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  makefile = "Makefile";

  meta = {
    description = "Prboom libretro port";
    homepage = "https://github.com/libretro/libretro-prboom";
    license = lib.licenses.gpl2Only;
  };
}
