{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-10-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "63c4190785cadd5ff84483399375871ed6e98754";
    hash = "sha256-oJlohamgPzBAwnksWmjnsHj9lDsr2nwLngfrMmsGA5k=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
