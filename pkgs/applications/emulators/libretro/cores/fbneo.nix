{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-12-25";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "9e65eff7536221b42f23e6df7e4eefb570e03baa";
    hash = "sha256-biZGZCtWMcqoI60dIJwkhLa5bXPrRhsih2Rh5OkKdbo=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
