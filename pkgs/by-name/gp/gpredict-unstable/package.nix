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
    version = "2.4-unstable-2025-12-27";

    src = fetchFromGitHub {
      owner = "csete";
      repo = "gpredict";
      rev = "6d298e5be7c47374ac9e0136e27972dee833ad2e";
      hash = "sha256-nLLrI+j6qr5l+LKfVkebJgcYGOEdHXkFOh3OdaBZ3DU=";
    };

    patches = [ ];

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  })
