{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-07-28";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "211b4902d5b4440b0aa567dade4eebf77cd868aa";
    hash = "sha256-l2b2Lu9l5CwmfDsJazOdQ9mowxfAqJY4SEgtDxCnYxY=";
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
