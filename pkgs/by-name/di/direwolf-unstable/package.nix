{
  lib,
  fetchFromGitHub,
  direwolf,
  nix-update-script,
  hamlibSupport ? true,
  gpsdSupport ? false,
  extraScripts ? false,
}:

(direwolf.override {
  inherit hamlibSupport gpsdSupport extraScripts;
}).overrideAttrs
  (oldAttrs: {
    version = "1.8.1-unstable-2026-03-09";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "3b20d8210a1d6f77073fd3452bbe87a21ee35a79";
      hash = "sha256-w/D5RO5dfcTh3nCOxe/GaHTSbzCYm+J1cJCt1K9lAaw=";
    };

    dontVersionCheck = true;

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  })
