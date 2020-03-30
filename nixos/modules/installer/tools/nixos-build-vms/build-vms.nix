{ system ? builtins.currentSystem
, config ? {}
, networkExpr
}:

let nodes = import networkExpr; in

with import ../../../../lib/testing-python.nix {
  inherit system;
  pkgs = import ../../../../.. { inherit system config; };
};

(makeTest { inherit nodes; testScript = ""; }).driver
