{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2026-07-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "5b6e751f4abf368509146cd143c949c1946ac1ae";
    hash = "sha256-R9+cVqJWZHHyJ75fZXdz9xJSVCVOk1xuEs8kPUGkFDI=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
