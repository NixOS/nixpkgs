{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-01-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "3faea4f9c678bad8063f3a2774b051f42848c856";
    hash = "sha256-tH9XMBfg3O2oKIUeKWi2hl4yQuHa9BMgvkWjIxv/KIo=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
