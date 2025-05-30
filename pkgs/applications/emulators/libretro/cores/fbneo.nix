{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-05-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "d2cf158e9ba82fc7dfec592452e6113121665c19";
    hash = "sha256-dO1R0iIXEo2lrMSOJXlZBw2yXBfyB/1yFfRPYEEAojo=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
