{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-11-09";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "7c4e3b2f8c027ae54a3ad9c90d7f00fccde15de9";
    hash = "sha256-YPuMImDSXFqg+TVrBtBt6zaNb9ngg1jBLsMXv2Sk29c=";
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
