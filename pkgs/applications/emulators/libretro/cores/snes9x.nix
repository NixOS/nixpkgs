{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "snes9x";
  version = "1.63-unstable-2024-12-08";

  src = fetchFromGitHub {
    owner = "snes9xgit";
    repo = "snes9x";
    rev = "9be3ed49a8711b016eb7280b758995bf2cbca4dd";
    hash = "sha256-3FE90o+OJYiBzaiLEggZZ3jbLCFTRMwI/ayaJ5clm4c=";
  };

  makefile = "Makefile";
  preBuild = "cd libretro";

  meta = {
    description = "Port of SNES9x git to libretro";
    homepage = "https://github.com/snes9xgit/snes9x";
    license = lib.licenses.unfreeRedistributable;
  };
}
