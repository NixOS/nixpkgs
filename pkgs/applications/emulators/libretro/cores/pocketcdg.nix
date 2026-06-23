{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "pocketcdg";
  version = "0-unstalble-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-pocketcdg";
    rev = "cdcd460d9a01ff2e8d61f650b554812f39ec530a";
    hash = "sha256-0XlO5IjgWVY728B6f+D6RcmnEyPGl84Flm1Ioxdt5kY=";
  };

  makefile = "Makefile";

  meta = {
    description = "PocketCDG libretro port";
    homepage = "https://github.com/libretro/libretro-pocketcdg";
    license = lib.licenses.mit;
  };
}
