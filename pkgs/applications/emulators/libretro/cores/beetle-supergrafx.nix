{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-supergrafx";
  version = "0-unstable-2024-11-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-supergrafx-libretro";
    rev = "a776133c34ae8da5daf7d9ccb43e3e292e2b07b0";
    hash = "sha256-FemWW4EPQCwhrS7YEytf6fEeimdTTfzaDdyRNDIBQyk=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's SuperGrafx core to libretro";
    homepage = "https://github.com/libretro/beetle-supergrafx-libretro";
    license = lib.licenses.gpl2Only;
  };
}
