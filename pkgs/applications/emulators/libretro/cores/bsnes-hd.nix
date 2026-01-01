{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  xorg,
}:
mkLibretroCore {
  core = "bsnes-hd-beta";
<<<<<<< HEAD
  version = "0-unstable-2025-12-05";
=======
  version = "0-unstable-2024-10-21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "DerKoun";
    repo = "bsnes-hd";
<<<<<<< HEAD
    rev = "fc26b25ea236f0f877f0265d2a2c37dfd93dfde9";
    hash = "sha256-Bim8N3rkGNnHQhaA+wVALSM3ZBBTk0Zt9xct5qVnXzM=";
=======
    rev = "0bb7b8645e22ea2476cabd58f32e987b14686601";
    hash = "sha256-YzWSZMn6v5hWIHnp6KmmpevCsf35Vi2BCcmFMnrFPH0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  extraBuildInputs = [
    xorg.libX11
    xorg.libXext
  ];

  makefile = "GNUmakefile";
  makeFlags = [
    "-C"
    "bsnes"
    "target=libretro"
    "platform=linux"
  ];

  postBuild = "cd bsnes/out";

  meta = {
    description = "Port of bsnes-hd to libretro";
    homepage = "https://github.com/DerKoun/bsnes-hd";
    license = lib.licenses.gpl3Only;
  };
}
