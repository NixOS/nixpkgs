{
  lib,
  fetchFromGitHub,
  goocanvas_3,
  nix-update-script,
  gpredict,
}:

(gpredict.override {
  goocanvas_2 = goocanvas_3;
}).overrideAttrs
  (finalAttrs: {
    version = "2.4-unstable-2026-02-02";

    src = fetchFromGitHub {
      owner = "csete";
      repo = "gpredict";
      rev = "2a57f14693e0af49235dc80c905f54a058fabc07";
      hash = "sha256-brjGM8EHKNnrxFVNMmN1GoPDnqP4kyur/GY0l8UW1b8=";
    };

    patches = [ ];

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  })
