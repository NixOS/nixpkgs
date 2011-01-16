{ nixos
, nixpkgs
, services ? "/etc/nixos/services"
, system ? builtins.currentSystem
, networkExpr
, useBackdoor ? false
}:

let nodes = import networkExpr;
in
with import "${nixos}/lib/testing.nix" { inherit nixpkgs services system useBackdoor; };

(complete { inherit nodes; testScript = ""; }).driver
