{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-11-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "79fa66dde4caea81b51910b7ea907951651e5fea";
    hash = "sha256-MBMxuRdgafar5zdlYLnIoIalBzuK3XS0FwuyllOab18=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
