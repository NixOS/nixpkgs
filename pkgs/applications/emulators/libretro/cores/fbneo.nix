{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-07-28";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "c79a2611849c6b2e76b638659f6f28b3244bd627";
    hash = "sha256-5EfZIM+tXBCsCI/tktW9yS2V6zlmWSxnlGv0JP51fbI=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
