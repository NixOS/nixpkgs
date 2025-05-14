{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-04-29";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "e13b683c5236adf8560613a883a0af8841ee49cb";
    hash = "sha256-0kAxCVcVMz6pxScVZhEvPWIHj29cO9xoI1bhgyXUMvU=";
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
