{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2026-06-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "69e86ebe89f14c3f5f75b809c12c0a953b3d6ce4";
    hash = "sha256-ppdwcE66igBarGAiupKB8pkRY8y5x/EPobiqJz93plA=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
