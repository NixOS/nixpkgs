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
    version = "1.8.1-unstable-2026-07-06";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "160cbb40a3828e47bc977b6f7d5499d1f1cf56e5";
      hash = "sha256-q08QuyWGYqLLz77JXlkJetrYMVQwQVUgjIXz9J4Y9VA=";
    };

    dontVersionCheck = true;

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  })
