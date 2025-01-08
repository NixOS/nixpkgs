{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "7.0-unstable-2024-12-18";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "dacf66131c938635a7017de364ba999ebbb35bb7";
    hash = "sha256-X6haV9SKQn2lnWs5kcNePP9wfz3G3yq/rEIGiPiBTOY=";
  };

  makefile = "Makefile";
  preBuild = "cd src/os/libretro";
  dontConfigure = true;

  meta = {
    description = "Port of Stella to libretro";
    homepage = "https://github.com/stella-emu/stella";
    license = lib.licenses.gpl2Only;
  };
}
