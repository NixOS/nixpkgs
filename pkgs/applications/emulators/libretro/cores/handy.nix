{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "handy";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-handy";
    rev = "ae216ac46e15b0f7af20d0d42042d7db1a28ec96";
    hash = "sha256-KKYdAEzFnUCbzanB8P+ME2pEdz90eAzAE79pTOFSHZo=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Handy to libretro";
    homepage = "https://github.com/libretro/libretro-handy";
    license = lib.licenses.zlib;
  };
}
