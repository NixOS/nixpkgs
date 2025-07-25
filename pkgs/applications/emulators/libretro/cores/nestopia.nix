{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2025-07-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "0e82a1642d4acafab4da9ce937954b85d846952b";
    hash = "sha256-/r1EUb3Z6RaEycGnkU4RtYr0JjohgQmru99DG45OWKo=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
