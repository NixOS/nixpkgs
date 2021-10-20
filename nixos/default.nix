{ configuration ? import ./lib/from-env.nix "NIXOS_CONFIG" <nixos-config>
, system ? builtins.currentSystem
}:

let

  eval = import ./lib/eval-config.nix {
    inherit system;
    modules = [ configuration ];
  };

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
        ({ config, ... }: {
          virtualisation.useEFIBoot =
            config.boot.loader.systemd-boot.enable ||
            config.boot.loader.efi.canTouchEfiVariables;
        })
      ];
  }).config;

in

{
  inherit (eval) pkgs config options;

  system = eval.config.system.build.toplevel;

  vm = vmConfig.system.build.vm;

  vmWithBootLoader = vmWithBootLoaderConfig.system.build.vm;
}
