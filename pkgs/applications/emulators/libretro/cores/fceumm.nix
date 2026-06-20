{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2026-06-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "c0c52ad0eb36cdbfc66e9bdb72efc83103e85e22";
    hash = "sha256-e81kpVUTz3l9wqCwN9Zf4LrnskPRW7Ewy78/1BApZlg=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
