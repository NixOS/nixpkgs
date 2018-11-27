let
  looks-like-nixos-lib = { path, prefix }:
    prefix == "nixos-lib" ||
    (prefix == "" && builtins.pathExists "${path}/nixos-lib");
in

{ configuration ? import ./lib/from-env.nix "NIXOS_CONFIG" <nixos-config>
, lib ? if builtins.any looks-like-nixos-lib builtins.nixPath
          then import <nixos-lib>
          else import ../lib
, system ? builtins.currentSystem
}:

let

  eval = import ./lib/eval-config.nix {
    inherit system;
    modules = [ configuration ];
    specialArgs = {
      inherit lib;
    };
  };

  # This is for `nixos-rebuild build-vm'.
  vmConfig = (import ./lib/eval-config.nix {
    inherit system;
    modules = [ configuration ./modules/virtualisation/qemu-vm.nix ];
    specialArgs = {
      inherit lib;
    };
  }).config;

  # This is for `nixos-rebuild build-vm-with-bootloader'.
  vmWithBootLoaderConfig = (import ./lib/eval-config.nix {
    inherit system;
    modules =
      [ configuration
        ./modules/virtualisation/qemu-vm.nix
        { virtualisation.useBootLoader = true; }
      ];
    specialArgs = {
      inherit lib;
    };
  }).config;

in

{
  inherit (eval) pkgs config options;

  system = eval.config.system.build.toplevel;

  vm = vmConfig.system.build.vm;

  vmWithBootLoader = vmWithBootLoaderConfig.system.build.vm;
}
