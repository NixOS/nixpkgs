# Can be used to inspect the JSON output of the evaluator.
#
# Run via:
# nix-instantiate --eval --json --strict ./example | jq
let
  sources = import ../npins;
  pkgs = import sources.nixpkgs { };
  config = import "${sources.nixpkgs}/nixos/lib/eval-config.nix" {
    modules = [
      ../nix_vars/nix/module.nix
      ./config.nix
    ];
  };
in
import ../nix_vars/nix/jsonify.nix {
  inherit config;
  pkgsHost = pkgs;
}
