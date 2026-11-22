{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "same_cdi";
  version = "0-unstable-2026-09-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "same_cdi";
    rev = "ff9bb99a50d518aef6d2add1c49b7c44447e3e78";
    hash = "sha256-njOlXPMmfI408B5/aFKwg8Z9+FJvScxhnWOauvMnZao=";
  };

  meta = {
    description = "SAME_CDI is a libretro core to play CD-i games";
    homepage = "https://github.com/libretro/same_cdi";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
  };
}
