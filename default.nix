{ configuration ? import ./lib/from-env.nix "NIXOS_CONFIG" /etc/nixos/configuration.nix
}:

let
  
  inherit
    (import ./lib/eval-config.nix {inherit configuration;})
    config optionDeclarations pkgs;

  vmConfig = (import ./lib/eval-config.nix {
    inherit configuration;
    extraModules = [./modules/virtualisation/qemu-vm.nix];
  }).config;
    
in

{
  inherit config;

  system = config.system.build.system;

  vm = vmConfig.system.build.vm;

  # The following are used by nixos-rebuild.
  nixFallback = pkgs.nixUnstable;
  manifests = config.installer.manifests;

  tests = config.tests;
}
