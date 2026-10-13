{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-10-12";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "2c3d7023e9136f75c789803b44f119d8749dc104";
    hash = "sha256-68RlXEX23UY/6gAUPL1IGsM5+BKU/26SNIWmfQsEi6M=";
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
