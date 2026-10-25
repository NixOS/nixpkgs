{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "neocd";
  version = "0-unstable-2026-10-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "neocd_libretro";
    rev = "b1e04c738cb48a1dae0574b8877f6a116d270ca1";
    hash = "sha256-z8bSy5FhfHIIS1wX4cGcnDesTUYlmvEvXdfZPoFQnYw=";
  };

  makefile = "Makefile";

  meta = {
    description = "NeoCD libretro port";
    homepage = "https://github.com/libretro/neocd_libretro";
    license = lib.licenses.lgpl3Only;
  };
}
