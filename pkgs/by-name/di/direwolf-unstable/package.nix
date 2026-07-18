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
    version = "1.8.1-unstable-2026-07-16";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "078b2e8484be379d4e1eab139c6fd57c188c1754";
      hash = "sha256-Wje8GsdMcUptQEVsG7Ww8nW3PUuk/Y67zsjf+KjPPB8=";
    };

    dontVersionCheck = true;

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  })
