# Don't forget to use --file argument to specify to use this file
let
  nixosSystem = import <nixpkgs/nixos/lib/eval-config.nix>;
in
nixosSystem {
  modules = [
    ./configuration.nix
  ];
}
