{ configuration ? import ./lib/from-env.nix "NIXOS_CONFIG" <nixos-config>
, system ? builtins.currentSystem
}:

let

  eval = import ./lib/eval-config.nix {
    inherit system;
    modules = [ configuration ];
  };

  # This is for `nixos-rebuild build-vm'.
  vm = eval.extendModules {
    modules = [ ./modules/virtualisation/qemu-vm.nix ];
  };

  # This is for `nixos-rebuild build-vm-with-bootloader'.
  vmWithBootLoader = vm.extendModules {
    modules = [
      ({ config, ... }: {
        _file = "nixos/default.nix##vmWithBootLoader";
        virtualisation.useBootLoader = true;
        virtualisation.useEFIBoot =
          config.boot.loader.systemd-boot.enable ||
          config.boot.loader.efi.canTouchEfiVariables;
      })
    ];
  };

in

{
  inherit (eval) pkgs config options;

  system = eval.config.system.build.toplevel;

  vm = vm.config.system.build.vm;

  vmWithBootLoader = vmWithBootLoader.config.system.build.vm;
}
