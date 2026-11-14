{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  unstableGitUpdater,
}:
mkLibretroCore {
  core = "puae2021";
  version = "0-unstable-2026-11-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "5dbac2bf90b2dddf9d3f8d5b2ccad0651f798c1d";
    hash = "sha256-muHm7OHglvmMyNgGs0Y79P3bq1msqD3FlJjrHZNZ/aw=";
  };

  makefile = "Makefile";

  # puae2021 is built from the 2.6.1 branch; master builds the puae core
  passthru.updateScript = unstableGitUpdater {
    branch = "2.6.1";
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Amiga emulator based on WinUAE (Version 2021)";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
