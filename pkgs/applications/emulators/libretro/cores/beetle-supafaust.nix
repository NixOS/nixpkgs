{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-supafaust";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "supafaust";
    rev = "2b93c0d7dff5b8f6c4e60e049d66849923fa8bba";
    hash = "sha256-cK+2MR4dJBhTRkPRuRtP2zWGw+mROZMgUOLc8BOxuz8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's experimental snes_faust core to libretro";
    homepage = "https://github.com/libretro/supafaust";
    license = lib.licenses.gpl2Only;
  };
}
