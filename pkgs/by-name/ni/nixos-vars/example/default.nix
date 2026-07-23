let
  pkgs = import ../../../../.. { };
in
import ../nix_vars/nix/jsonify.nix {
  config = import ./config;
  pkgsTarget = pkgs;
  pkgsHost = pkgs;
}
