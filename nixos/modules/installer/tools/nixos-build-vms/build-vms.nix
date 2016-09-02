{ system ? builtins.currentSystem
, networkExpr
}:

let nodes = import networkExpr; in

with import ../../../../../lib/testing/testing.nix { inherit system; };

(makeTest { inherit nodes; testScript = ""; }).driver
