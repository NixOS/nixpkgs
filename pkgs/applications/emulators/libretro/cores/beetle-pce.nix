{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pce";
  version = "0-unstable-2025-06-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pce-libretro";
    rev = "9a301c0773c53702a882bbaa42ee9cbc6d523787";
    hash = "sha256-RS5omi6LthQy8fFfouSEpYtaeD7QDlRENm0YuqHzUc0=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PC Engine core to libretro";
    homepage = "https://github.com/libretro/beetle-pce-libretro";
    license = lib.licenses.gpl2Only;
  };
}
