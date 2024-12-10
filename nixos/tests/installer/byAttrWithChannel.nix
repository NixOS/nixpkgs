# This file gets copied into the installation

{ evalConfig ? import <nixpkgs/nixos/lib/eval-config.nix> }:

evalConfig {
  modules = [
    ./configuration.nix
    ( import <nixpkgs/nixos/modules/testing/test-instrumentation.nix> )
  ];
}
