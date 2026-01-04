{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-12-28";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "7f62c3e1390f629cbd56cbb5172f7e2143b30440";
    hash = "sha256-IMrqBu7beSuJNfl2pyzRm5yExXaMkl+si0YVDeRbAcU=";
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
