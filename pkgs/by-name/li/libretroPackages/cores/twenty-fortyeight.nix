{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "2048";
  version = "0-unstable-2026-08-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-2048";
    rev = "39333f7b13dc4daea7c151d9c38d22b961246343";
    hash = "sha256-sMmRG126yg1diRPY1YMUfkTvwYjjTKyAXo367/CvcYo=";
  };

  meta = {
    description = "Port of 2048 puzzle game to libretro";
    homepage = "https://github.com/libretro/libretro-2048";
    license = lib.licenses.unlicense;
  };
}
