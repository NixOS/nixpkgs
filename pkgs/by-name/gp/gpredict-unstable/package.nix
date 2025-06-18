{
  lib,
  fetchFromGitHub,
  goocanvas3,
  nix-update-script,
  gpredict,
}:

(gpredict.override {
  goocanvas2 = goocanvas3;
}).overrideAttrs
  (finalAttrs: {
    version = "2.2.1-unstable-2024-09-17";

    src = fetchFromGitHub {
      owner = "csete";
      repo = "gpredict";
      rev = "91a4a3fb15e7eab0374d1bb7c859d386818b48ee";
      hash = "sha256-/XCJ+jCSY4o0OLVVY6OGvnmMw6aI/iQOhjyLYWPj7Ec=";
    };

    patches = [ ];

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  })
