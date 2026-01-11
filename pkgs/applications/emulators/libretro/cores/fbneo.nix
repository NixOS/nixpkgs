{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2025-12-29";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "3ebf6ddb6aef21433cf2e323ad19bded912ee2f9";
    hash = "sha256-jCU0AtkKfuZOZLuRdJ6qBcRydQykYgSbbhskfmmSqOc=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
