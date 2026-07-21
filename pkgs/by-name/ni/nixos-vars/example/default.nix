# Can be used to inspect the JSON output of the evaluator.
#
# Run via:
# nix-instantiate --eval --json --strict ./example | jq
let
  pkgs = import ../../../../.. { };
in
import ../nix_vars/nix/jsonify.nix {
  # inherit config;
  config = import ./config;
  pkgsTarget = pkgs;
  pkgsHost = pkgs;
}
