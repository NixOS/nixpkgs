{ configuration ? import ./lib/from-env.nix "NIXOS_CONFIG" <nixos-config>
, system ? builtins.currentSystem
}:

let

  # NixOS library
  lib = import ./lib;

  eval = lib.eval-config {
    inherit system;
    modules = [ configuration ];
  };

  inherit (eval) pkgs;

  # This is for `nixos-rebuild build-vm'.
  vmConfig = (lib.eval-config {
    inherit system;
    modules = [ configuration ./modules/virtualisation/qemu-vm.nix ];
  }).config;

  # This is for `nixos-rebuild build-vm-with-bootloader'.
  vmWithBootLoaderConfig = (lib.eval-config {
    inherit system;
    modules =
      [ configuration
        ./modules/virtualisation/qemu-vm.nix
        { virtualisation.useBootLoader = true; }
      ];
  }).config;

in

{
  inherit (eval) config options lib;

  system = eval.config.system.build.toplevel;

  vm = vmConfig.system.build.vm;

  vmWithBootLoader = vmWithBootLoaderConfig.system.build.vm;

  # The following are used by nixos-rebuild.
  nixFallback = pkgs.nixUnstable.out;
}
