{ configuration ? import ./lib/from-env.nix "NIXOS_CONFIG" /etc/nixos/configuration.nix
, system ? builtins.currentSystem
}:

let
  
  eval = import ./lib/eval-config.nix {
    inherit system;
    modules = [ configuration ];
  };

  inherit (eval) config pkgs;

  # This is for `nixos-rebuild build-vm'.
  vmConfig = (import ./lib/eval-config.nix {
    inherit system;
    modules = [ configuration ./modules/virtualisation/qemu-vm.nix ];
  }).config;

  # This is for `nixos-rebuild build-vm-with-bootloader'.
  vmWithBootLoaderConfig = (import ./lib/eval-config.nix {
    inherit system;
    modules =
      [ configuration
        ./modules/virtualisation/qemu-vm.nix
        { virtualisation.useBootLoader = true; }
      ];
  }).config;
      
in

{
  inherit eval config;

  system = config.system.build.toplevel;

  vm = vmConfig.system.build.vm;

  vmWithBootLoader = vmWithBootLoaderConfig.system.build.vm;

  # The following are used by nixos-rebuild.
  nixFallback = pkgs.nixUnstable;
  manifests = config.installer.manifests;

  tests = config.tests;
}
