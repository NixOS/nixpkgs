{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "freeintv";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "freeintv";
    rev = "428915baf2bfc032fc03e645f4f8f9c6c3144979";
    hash = "sha256-S8sGHS56fQaSuoUllupYdieSLFzsUE3tmM7DUssA+NY=";
  };

  makefile = "Makefile";

  meta = {
    description = "FreeIntv libretro port";
    homepage = "https://github.com/libretro/freeintv";
    license = lib.licenses.gpl3Only;
  };
}
