{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-pce-fast";
  version = "0-unstable-2025-04-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-pce-fast-libretro";
    rev = "baa35513545b011faa8b0b5db334d24ba15539ed";
    hash = "sha256-jEvbHCK9AB4u3raWbAivscHqBiH9s+RkgExTVW1yvnk=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's PC Engine fast core to libretro";
    homepage = "https://github.com/libretro/beetle-pce-fast-libretro";
    license = lib.licenses.gpl2Only;
  };
}
