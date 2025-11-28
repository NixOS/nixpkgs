{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-11-26";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "ec7ad887c777a7924fdc786a9c5901e65d4c6cd0";
    hash = "sha256-M0DD+xNS+kf9x49YPZHulmYeV36fTh09rsRtQT+/zFY=";
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
