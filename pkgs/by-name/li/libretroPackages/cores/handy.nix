{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "handy";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-handy";
    rev = "bc55d462f0b2d6b073ea93dc552ebd73cec60fd1";
    hash = "sha256-g0b5TaUa4nm6uPosWW+kp68NX7VQKBkBeG4YAZY4TRo=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Handy to libretro";
    homepage = "https://github.com/libretro/libretro-handy";
    license = lib.licenses.zlib;
  };
}
