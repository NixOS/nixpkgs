{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-03-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "7706b59fecf5a8ef81190d8d7e0abe3b08ce6d22";
    hash = "sha256-D2PB2vaq1HpHAE0/c5I9YxwFPS8QQ4hSRuKu5xzJR/k=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
