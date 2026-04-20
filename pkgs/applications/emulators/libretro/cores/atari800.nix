{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore rec {
  core = "atari800";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-atari800";
    rev = "a9b9c433d8cb6c8e8eb08d14d3e95b430549723a";
    hash = "sha256-vPv6D+y+n9gMgC78cLBVeNLg3nGEAsTeBGFv+SWgH0A=";
  };

  makefile = "Makefile";
  makeFlags = [ "GIT_VERSION=${builtins.substring 0 7 src.rev}" ];

  meta = {
    description = "Port of Atari800 to libretro";
    homepage = "https://github.com/libretro/libretro-atari800";
    license = lib.licenses.gpl2Only;
  };
}
