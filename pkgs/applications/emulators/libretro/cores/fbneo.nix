{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-11-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "442a0e901c3d7d60c94f21caf46c0535233086f6";
    hash = "sha256-ewwF7btf5EEBmGzAVuH4LavrDpmVzEBD/BE1/T/p6bM=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
