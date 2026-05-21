{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-05-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "1a2d079aac28c540c20a9e4cac87bb02021c3eec";
    hash = "sha256-4q1q20Us7HVZr2CWsqujQWiqryc/xS9/bVBt/x7Y5H8=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
