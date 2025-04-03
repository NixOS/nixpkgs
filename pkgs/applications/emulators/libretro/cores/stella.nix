{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-03-17";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "aaa6c154750119905190da49569fa9e2de7bb97b";
    hash = "sha256-QephycS6p6KCAR5ryc8Nhx8jnFGHaY7kObT13RNU42Q=";
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
