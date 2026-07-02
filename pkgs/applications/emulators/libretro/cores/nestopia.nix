{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "b0fd87dd07e3c52903435d302b04e5e97796f127";
    hash = "sha256-OQcjGCAwXQEiWKYldKgOzMwIJcWTR308v+0OcuzFTo8=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
