{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-supafaust";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "supafaust";
    rev = "584ef2c5571f1ece95f6117aa04b7e8fee213fb1";
    hash = "sha256-aptn3igUIvU/ho+6iXAg0J7X5ymdWeTM+zL+BA06tG4=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's experimental snes_faust core to libretro";
    homepage = "https://github.com/libretro/supafaust";
    license = lib.licenses.gpl2Only;
  };
}
