{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "dosbox-pure";
<<<<<<< HEAD
  version = "0-unstable-2025-12-01";
=======
  version = "0-unstable-2025-10-25";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "schellingb";
    repo = "dosbox-pure";
<<<<<<< HEAD
    rev = "492d8a3996429dbaa4a13b2e90c522e7b34fc2bb";
    hash = "sha256-yNufp+HUzuLOiRhQfdP1ssKDTALwh28B8cRZ2rTJpis=";
=======
    rev = "11a9e9e451b5013c6a19d58b26bbc75316f4080d";
    hash = "sha256-+dD1JWYvD03pzW97PZbick3+GdriowrDCylww+YyBls=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  hardeningDisable = [ "format" ];
  makefile = "Makefile";

  meta = {
    description = "Port of DOSBox to libretro aiming for simplicity and ease of use";
    homepage = "https://github.com/schellingb/dosbox-pure";
    license = lib.licenses.gpl2Only;
  };
}
