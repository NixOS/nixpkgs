{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  libxext,
  libx11,
}:
mkLibretroCore {
  core = "bsnes-hd-beta";
  version = "0-unstable-2025-12-05";

  src = fetchFromGitHub {
    owner = "DerKoun";
    repo = "bsnes-hd";
    rev = "fc26b25ea236f0f877f0265d2a2c37dfd93dfde9";
    hash = "sha256-Bim8N3rkGNnHQhaA+wVALSM3ZBBTk0Zt9xct5qVnXzM=";
  };

  extraBuildInputs = [
    libx11
    libxext
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
