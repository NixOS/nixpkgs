{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-06-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "340f9e9014c292fc47a8844a871a71dafe072b6d";
    hash = "sha256-geBK8RIlaRcWn4CDzVl3pjK0WOFQcMZl7zFMXE2oZNo=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
