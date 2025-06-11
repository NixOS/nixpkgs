{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-05-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "60d812a5a25b7f6cc7df2842264b67847e51122b";
    hash = "sha256-4HJZXsgUp0do7T0bwPPuuyoN7XIII3DSzk6LsLqZQeQ=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
