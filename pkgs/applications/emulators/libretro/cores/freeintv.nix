{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "freeintv";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "freeintv";
    rev = "9b66d2b3c3406659b2fdfaade7a80f3e62772815";
    hash = "sha256-rJatbYyrS9vkGT8+jty80rPkcGGCV9enW5L40NeFwlE=";
  };

  makefile = "Makefile";

  meta = {
    description = "FreeIntv libretro port";
    homepage = "https://github.com/libretro/freeintv";
    license = lib.licenses.gpl3Only;
  };
}
