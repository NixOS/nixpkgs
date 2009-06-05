{ configuration ? import (import ./lib/from-env.nix "NIXOS_CONFIG" /etc/nixos/configuration.nix)
}:

let
  
  inherit
    (import ./lib/eval-config.nix {inherit configuration;})
    config optionDeclarations pkgs;

in

{
  system = config.system.build.system;

  # The following are used by nixos-rebuild.
  nixFallback = pkgs.nixUnstable;
  manifests = config.installer.manifests;

  tests = config.tests;
}
