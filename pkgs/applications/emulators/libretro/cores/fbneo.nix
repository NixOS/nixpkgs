{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-06-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "9723c47c2d782ccb8cf48f96568a89a44631e6ba";
    hash = "sha256-zYIC0up0tkvq0TLjSiypxwSTYAF1XnmHXsUTKsUQejA=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
