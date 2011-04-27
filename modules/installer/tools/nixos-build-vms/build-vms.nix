{ nixpkgs
, system ? builtins.currentSystem
, networkExpr
}:

let nodes = import networkExpr; in

with import ../../../../lib/testing.nix { inherit nixpkgs system; };

(complete { inherit nodes; testScript = ""; }).driver
