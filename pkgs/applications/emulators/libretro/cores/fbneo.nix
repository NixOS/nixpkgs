{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-08-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "4aa5e5b8ef4fc94143680fda8c598839bb336bdc";
    hash = "sha256-xO4v5BO9V/ECoM/Mr5weDlpPJCOzRnYMTlaSkO/UiYg=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
