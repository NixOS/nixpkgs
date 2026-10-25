{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-10-24";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "9a7c60328a94a5a8947c01d7e6efef0a33475b54";
    hash = "sha256-SXQwHfEEYu0C/6XEQV7ooLVtEXVSc6dCg3lUqCyyUsA=";
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
