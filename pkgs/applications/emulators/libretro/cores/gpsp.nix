{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "6373ff347a07ac17c50a00f20aa63d29c080abcf";
    hash = "sha256-1aLSJ0oB8WJnIfKHHdwBQ52uVPs1XiFZvgFgrF9zUoA=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
