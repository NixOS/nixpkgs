{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "bsnes";
  version = "0-unstable-2025-03-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "bsnes-libretro";
    rev = "ec353ea2502be9b71f3d9830b7a7b66ee69e254c";
    hash = "sha256-9QRKEIi1JHd503KN9+DKxLMJMJWyNu9vomPAmlbb/zw=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of bsnes to libretro";
    homepage = "https://github.com/libretro/bsnes-libretro";
    license = lib.licenses.gpl3Only;
  };
}
