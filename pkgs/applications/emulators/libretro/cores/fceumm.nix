{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2025-09-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "5cd4a43e16a7f3cd35628d481c347a0a98cfdfa2";
    hash = "sha256-/FvXQlp20QMFg1uPmj2HSJFXhzBunygOmGEtGNGJyxk=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
