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
    version = "1.8.1-unstable-2026-08-10";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "a821a0e4ffc2eb3ce94aafe1a9131aac7053042f";
      hash = "sha256-aFrKFErFVXoXX5bqNQj1rkwlaS67rIPGa7MNf8Wtal4=";
    };

    dontVersionCheck = true;

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  })
