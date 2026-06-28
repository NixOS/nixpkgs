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
    version = "1.8.1-unstable-2026-05-27";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "d6151874ecf202cbb401a671a90b15d0fab92fa9";
      hash = "sha256-t19AjQzjkpteqwfRVI/tM5wCVNeFceWPHjq0UtdevXg=";
    };

    dontVersionCheck = true;

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  })
