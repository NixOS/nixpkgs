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
    version = "1.8.1-unstable-2026-09-08";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "f11c82b81a23ca425f91bf9810fe9e2dc4f7539e";
      hash = "sha256-D2vzwc4PK5CUXbSQV4u/lAriRh2drsNPLt6ADN6a8fs=";
    };

    dontVersionCheck = true;

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  })
