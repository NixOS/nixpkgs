{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "uzem";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uzem";
    rev = "d4fe82c38bf3fc789b955bcfcc81dc2e3a2ea89f";
    hash = "sha256-zS2Sr/IP/kAQoXNhRH37ZfQevVKVQAKlNwlaC43dkuw=";
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
