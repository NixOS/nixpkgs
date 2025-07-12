{
  config,
  extendModules,
  lib,
  ...
}:
let

  inherit (lib)
    mkOption
    ;

  vmVariant = extendModules {
    modules = [ ./qemu-vm.nix ];
  };

  vmVariantWithBootLoader = vmVariant.extendModules {
    modules = [
      (
        { config, ... }:
        {
          _file = "nixos/default.nix##vmWithBootLoader";
          virtualisation.useBootLoader = true;
          virtualisation.useEFIBoot =
            config.boot.loader.systemd-boot.enable || config.boot.loader.efi.canTouchEfiVariables;
        }
      )
    ];
  };
in
{
  options = {

    virtualisation.vmVariant = mkOption {
      description = ''
        Machine configuration to be added for the vm script produced by `nixos-rebuild build-vm`.
      '';
      inherit (vmVariant) type;
      default = { };
      visible = "shallow";
    };

    virtualisation.vmVariantWithBootLoader = mkOption {
      description = ''
        Machine configuration to be added for the vm script produced by `nixos-rebuild build-vm-with-bootloader`.
      '';
      inherit (vmVariantWithBootLoader) type;
      default = { };
      visible = "shallow";
    };

  };

  config = {

    system.build = {
      vm = lib.mkDefault config.virtualisation.vmVariant.system.build.vm;
      vmWithBootLoader = lib.mkDefault config.virtualisation.vmVariantWithBootLoader.system.build.vm;
    };

    virtualisation.vmVariant = {
      options = {
        virtualisation.vmVariant = lib.mkOption {
          apply = _: throw "virtualisation.vmVariant*.virtualisation.vmVariant is not supported";
        };
        virtualisation.vmVariantWithBootLoader = lib.mkOption {
          apply =
            _: throw "virtualisation.vmVariant*.virtualisation.vmVariantWithBootloader is not supported";
        };
      };
    };

  };

  # uses extendModules
  meta.buildDocsInSandbox = false;
}
