{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "freeintv";
  version = "0-unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "freeintv";
    rev = "ef3e0fe322bec62a7f916c0bb0834c08c348d0b4";
    hash = "sha256-VS0uB2afgDaZUww7iY9QcBJ+iA3haLQrjpNvhzFj1QA=";
  };

  makefile = "Makefile";

  meta = {
    description = "FreeIntv libretro port";
    homepage = "https://github.com/libretro/freeintv";
    license = lib.licenses.gpl3Only;
  };
}
