{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "uzem";
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uzem";
    rev = "d991ee94547c8294abc1c4cb73d63116aa58b5bc";
    hash = "sha256-EVvcJ2eBiTAG2paYsE6cPgFaRh70rRto6riZRuarbm0=";
  };

  makefile = "Makefile";
  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];
  postPatch = ''
    substituteInPlace Makefile.libretro \
      --replace-fail 'GIT_VERSION := " $(shell git rev-parse --short HEAD)"' 'GIT_VERSION ?='
  '';

  meta = {
    description = "Uzebox emulator for Libretro";
    homepage = "https://github.com/libretro/libretro-uzem";
    license = lib.licenses.mit;
  };
}
