{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  xorg,
}:
mkLibretroCore {
  core = "bsnes-hd-beta";
  version = "0-unstable-2023-04-26";

  src = fetchFromGitHub {
    owner = "DerKoun";
    repo = "bsnes-hd";
    rev = "f46b6d6368ea93943a30b5d4e79e8ed51c2da5e8";
    hash = "sha256-Y3FhGtcz7BzwUSBy1SGMuylJdZti/JB8qQnabIkG/dI=";
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
