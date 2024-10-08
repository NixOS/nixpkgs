{ callPackage }:
let
  openfoam = callPackage ./generic.nix {
    version = "2406";
    sourceRev = "OpenFOAM-v2406";
    sourceHash = "sha256-zttAj6eJ//GjuyjfNGXJoL2de/daJ9xGZg2JqJTo7rU=";

    inherit openfoam;
  };
in
openfoam
