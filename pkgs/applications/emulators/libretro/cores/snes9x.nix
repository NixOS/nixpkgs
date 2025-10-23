{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x";
  version = "0-unstable-2025-10-16";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = "abfc018c90799eb55b773fc46d486167d8b3c762";
    hash = "sha256-7PXUGUfhieYz8rLDhfLq09AcJbEcTLC/peYYN/B07c4=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Port of SNES9x git to libretro";
    homepage = "https://github.com/snes9xgit/snes9x";
    license = lib.licenses.unfreeRedistributable;
  };
}
