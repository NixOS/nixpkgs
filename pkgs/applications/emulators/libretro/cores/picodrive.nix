{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "picodrive";
  version = "0-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "picodrive";
    rev = "f0d4a0118a9733a1f10bce5a4ac772c474f9300d";
    hash = "sha256-q584bnqIbKoXSCRHUAcqSJAIhholnXfbphvLVcbm57o=";
    fetchSubmodules = true;
  };

  dontConfigure = true;

  meta = {
    description = "Fast MegaDrive/MegaCD/32X emulator";
    homepage = "https://github.com/libretro/picodrive";
    license = lib.licenses.unfreeRedistributable;
  };
}
