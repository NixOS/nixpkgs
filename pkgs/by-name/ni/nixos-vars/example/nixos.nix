# This is here for when I want to attempt to pass a pre-evaluated NixOS config
# to the CLI.
let
  config = import ../../../../../nixos/lib/eval-config.nix {
    modules = [
      ./config.nix
    ];
  };
in
config
