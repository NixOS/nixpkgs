{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-02-17";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "96ae794b56de38eafe4fc82086a329147427bc7a";
    hash = "sha256-TH+rgl1HlI2yRe8PW60EVYA0Q+bF7gSpIxRZA5jLnUc=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
