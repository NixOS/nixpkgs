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
    version = "1.8.1-unstable-2026-03-18";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "78d6559c67b94568b2f093fc9b4d4965749387ae";
      hash = "sha256-sSXvDTnrOHplmg86kZ+ppPD0Y6JuhHBfrXZToK8EqmY=";
    };

    dontVersionCheck = true;

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  })
