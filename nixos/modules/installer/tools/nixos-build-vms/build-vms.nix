{ system ? builtins.currentSystem
, config ? {}
, networkExpr
}:

let nodes = import networkExpr; in

with import ../../../../lib/testing.nix {
  inherit system;
  pkgs = import ../../../../.. { inherit system config; };
};

(makeTest { inherit nodes; testScript = ""; }).driver
