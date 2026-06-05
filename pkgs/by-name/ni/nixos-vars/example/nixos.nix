# This is here for when I want to attempt to pass a pre-evaluated NixOS config
# to the CLI.
let
  sources = import ../npins;
  config = import "${sources.nixpkgs}/nixos/lib/eval-config.nix" {
    modules = [
      ../src/nix/module.nix
      ./config.nix
    ];
  };
in
config
