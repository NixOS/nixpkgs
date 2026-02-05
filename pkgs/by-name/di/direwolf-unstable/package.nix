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
    version = "1.8.1-unstable-2026-01-08";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "041f396de0ab2111b9ccc07960f8f083a81f9ad0";
      hash = "sha256-W0MTS4UgbtIybhEHXm2ie50TnkvRLc23WB0FR0FGT2s=";
    };

    dontVersionCheck = true;

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  })
