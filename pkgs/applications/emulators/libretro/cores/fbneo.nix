{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-04-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "ffdacc6a7ce719b6371ad0a6143ce46726ed5d25";
    hash = "sha256-Pdp/pPsZujbAK6pEE5LT6KCdJ/RFW1zR67bWvI/efJI=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
