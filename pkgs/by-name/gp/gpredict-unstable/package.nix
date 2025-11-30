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
    version = "2.2.1-unstable-2025-09-20";

    src = fetchFromGitHub {
      owner = "csete";
      repo = "gpredict";
      rev = "34af48e6bfd9647559abb1df4907a65d064fc870";
      hash = "sha256-G4bS7w/USIzYOa+aYv3YQCbUQolV22Z/7+71GHHSUpk=";
    };

    patches = [ ];

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  })
