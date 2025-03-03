{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-03-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "74a979724da9a3c4c8986076123c3293861614c5";
    hash = "sha256-2xy62BCt6q3ePQaoQ6Z915ZyMnjTV2uTATz1y73FZCk=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
