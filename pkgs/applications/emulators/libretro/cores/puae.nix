{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-04-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "0faf39cfd84e114d985e020562e75c22b4bc1569";
    hash = "sha256-eJnCHei0/SdJD33SGsRgUL1+IapcvX/FcxHDlYmkob0=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
