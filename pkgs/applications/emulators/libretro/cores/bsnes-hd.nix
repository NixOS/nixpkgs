{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  xorg,
}:
mkLibretroCore {
  core = "bsnes-hd-beta";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "DerKoun";
    repo = "bsnes-hd";
    rev = "0bb7b8645e22ea2476cabd58f32e987b14686601";
    hash = "sha256-YzWSZMn6v5hWIHnp6KmmpevCsf35Vi2BCcmFMnrFPH0=";
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
