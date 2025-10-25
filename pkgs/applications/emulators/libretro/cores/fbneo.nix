{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-10-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "78dcc8a994ad9b51e487d4e52671f7a6ae20b5c2";
    hash = "sha256-becm8E66A0/sCHVwccmqPfc0Q+37pm7mRIJsTpphRZc=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
