{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2026-06-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "f87bc875bd68262211e2e01ffbaf3662626a3e4f";
    hash = "sha256-TUrhDbRArO/RISZawu5p9FIZlFf8pPlBrD9WRrdSRPk=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
