{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-04-19";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "7b5c19ff5e28dfeb814e912d028cb34b53c01f10";
    hash = "sha256-RdRdmvUZB1jGgeuNBGhqztZadag0/8USTjtTAKjaxSo=";
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
