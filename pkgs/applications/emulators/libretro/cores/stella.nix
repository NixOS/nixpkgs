{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2026-02-18";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "30b15892eec8aac36075e07b2f719bf7ff494344";
    hash = "sha256-mgu7JmZ9veng6WauFEUW5nON9vlrnXsgmLU7wzTZhTY=";
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
