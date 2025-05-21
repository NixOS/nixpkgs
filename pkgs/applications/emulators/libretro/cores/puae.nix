{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae";
  version = "0-unstable-2025-05-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "d3c925ef4fadee6c25bcef20d1f165141ba18ac3";
    hash = "sha256-Wo58+4XSxEVtlKsHmW90Qhm+kdUHmDvN3d2gASNiIrw=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
  };
}
