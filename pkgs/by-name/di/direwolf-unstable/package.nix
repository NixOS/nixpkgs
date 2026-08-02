{
  lib,
  fetchFromGitHub,
  direwolf,
  nix-update-script,
  hamlibSupport ? true,
  gpsdSupport ? true,
  extraScripts ? false,
}:

(direwolf.override {
  inherit hamlibSupport gpsdSupport extraScripts;
}).overrideAttrs
  (oldAttrs: {
    version = "1.8.1-unstable-2026-07-19";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "e8ab49a5e4d3edd49cfa9b7b9d65334693d2da5d";
      hash = "sha256-+HYcfdMTDAzm5quT67YhsH4TuUcsHSRBPiucCk+qgDw=";
    };

    dontVersionCheck = true;

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  })
