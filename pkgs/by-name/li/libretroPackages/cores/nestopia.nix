{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2026-08-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "1200c7c476026eebc8f25a107413e955a39952b6";
    hash = "sha256-Rh9iah+gjYbtKFoA7e8v70AuDJm0ZxxeXsvPyISt9QE=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
