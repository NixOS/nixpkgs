{ nixos
, nixpkgs
, services ? "/etc/nixos/services"
, system ? builtins.currentSystem
, networkExpr
, useBackdoor ? false
}:

let nodes = import networkExpr;
in
(import "${nixos}/lib/build-vms.nix" {
  inherit nixpkgs services system useBackdoor;
})
.buildVirtualNetwork {
  inherit nodes;
}
