{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "nestopia";
  version = "0-unstable-2026-02-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "nestopia";
    rev = "c0ae3bcbe78a1a21a20384b96b70774cc165d2c2";
    hash = "sha256-T4SC2yH/il6fjYd+4cWK4c+VqHMBc0uR3sXzPF6Z4O0=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Nestopia libretro port";
    homepage = "https://github.com/libretro/nestopia";
    license = lib.licenses.gpl2Only;
  };
}
