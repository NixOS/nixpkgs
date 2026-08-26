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
    version = "1.8.1-unstable-2026-08-13";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "eee56cce8e7c1719b5b899e64843148bd9f045c3";
      hash = "sha256-8KUFK6Bb3gMz5uBbyJRjDFYNnoJ5LXV06j5hnc8Tqew=";
    };

    dontVersionCheck = true;

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  })
