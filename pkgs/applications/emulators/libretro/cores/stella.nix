{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-05-17";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "8421af89314bbdcf118d4b3884a9f566e4b1020e";
    hash = "sha256-uffcz8TXb0vEivOEcnL288YT8rspSOGcNdXtGijXX1g=";
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
