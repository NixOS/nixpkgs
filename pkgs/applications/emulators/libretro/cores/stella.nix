{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "stella";
  version = "0-unstable-2025-06-12";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    rev = "ee0b96cd87710ad19aa47156d39df5a92c156a34";
    hash = "sha256-BnDF/UC3GiBC/06zBCDYrWA5cJPv7vtJ0grYgn5CcKo=";
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
