# This file gets copied into the installation

let
  nixpkgs = "@nixpkgs@";
in

{
  evalConfig ? import "${nixpkgs}/nixos/lib/eval-config.nix",
}:

evalConfig {
  modules = [
    ./configuration.nix
    (import "${nixpkgs}/nixos/modules/testing/test-instrumentation.nix")
    {
      # Disable nix channels
      nix.channel.enable = false;
    }
  ];
}
