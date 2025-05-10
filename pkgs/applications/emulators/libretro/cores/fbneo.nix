{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-05-09";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "922fb2c9d7541b3554f7e5364a6072da241a9837";
    hash = "sha256-LVQlWznu0wGlyFDexNaMqYjqHHNDeLLa6oeGvqGAjPQ=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
