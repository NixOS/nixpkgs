{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prosystem";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "prosystem-libretro";
    rev = "3f465db9c82fc6764cd90c53fc66eb630e0b3710";
    hash = "sha256-uamxOzJt5NbMGxDqyGk/8XJbN/fiFoB81DNeULIfL1U=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of ProSystem to libretro";
    homepage = "https://github.com/libretro/prosystem-libretro";
    license = lib.licenses.gpl2Only;
  };
}
