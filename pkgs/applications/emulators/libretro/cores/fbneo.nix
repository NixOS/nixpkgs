{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fbneo";
  version = "0-unstable-2026-02-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "fbneo";
    rev = "946de34101cd59701d66a8d2ec38394a6057740f";
    hash = "sha256-Alzl84MAkSAr8CkqursthVc1eWn7McsNangjxFAaAQA=";
  };

  makefile = "Makefile";
  preBuild = "cd src/burner/libretro";

  meta = {
    description = "Port of FBNeo to libretro";
    homepage = "https://github.com/libretro/fbneo";
    license = lib.licenses.unfreeRedistributable;
  };
}
