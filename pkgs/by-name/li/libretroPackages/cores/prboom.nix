{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prboom";
  version = "0-unstable-2026-09-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-prboom";
    rev = "ddea2c6c041f7790c7bcf1dc3c1fe73b6cff0516";
    hash = "sha256-Gjog5egR49CqERDHMgxDhWE2OQeDZd57NpJ5c/jSOx4=";
  };

  makefile = "Makefile";

  meta = {
    description = "Prboom libretro port";
    homepage = "https://github.com/libretro/libretro-prboom";
    license = lib.licenses.gpl2Only;
  };
}
