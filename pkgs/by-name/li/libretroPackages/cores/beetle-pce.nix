{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pce";
  version = "0-unstable-2026-09-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pce-libretro";
    rev = "6d6a35eb802e8ff3479f383fff08975842c7376d";
    hash = "sha256-X1UB/6Qa+57fr0vXOSuepWIwccSYwaoqjchrQmQ3Y1Q=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PC Engine core to libretro";
    homepage = "https://github.com/libretro/beetle-pce-libretro";
    license = lib.licenses.gpl2Only;
  };
}
