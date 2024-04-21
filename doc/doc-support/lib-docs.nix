{ pkgs, nixpkgs, libsets }:

import ./generate-function-docs.nix {
  inherit pkgs nixpkgs libsets;
  library = pkgs.lib;
  src = ../../lib;
}
