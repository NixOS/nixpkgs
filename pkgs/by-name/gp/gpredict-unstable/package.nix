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
    version = "2.5.1-unstable-2026-04-09";

    src = fetchFromGitHub {
      owner = "csete";
      repo = "gpredict";
      rev = "73937f7e9825747d8482884d25c65904b5ff0ef5";
      hash = "sha256-bPHhAjFOB8RdtnOirywsN2o5LQKqSlNy7j+ftRrfxDs=";
    };

    patches = [ ];

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  })
