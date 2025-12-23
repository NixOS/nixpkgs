{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-12-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "a4a563a372b201d8cbac94fb9c50694f6f7137e9";
    hash = "sha256-KQJiwCnaLILy5fgIraTCI0y7eBL14nZnbHa0m8YHq6g=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
