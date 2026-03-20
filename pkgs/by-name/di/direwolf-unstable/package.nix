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
    version = "1.8.1-unstable-2026-03-12";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "0663670550073c9d89917d5ac78df65e551d237a";
      hash = "sha256-4A9595Z3to/HBW1WS1mLYQDGokmSz3ClfRDhsLxIj0E=";
    };

    dontVersionCheck = true;

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  })
