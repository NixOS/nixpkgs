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

    virtualisation.isVmVariant = mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        This option is `true` if the machine configurations was produced by `nixos-rebuild build-vm`.
        Unlike {option}`virtualisation.vmVariant`, where you can set definitions that are only for the
        VM, this option can be read from to make definitions conditional in the context being _not_ the VM variant.
        Example: `lib.mkIf (!config.virtualisation.isVmVariant) { ... }`.
      '';
    };

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
      config = {
        # `lib.mkOverride 0` to match `isSpecialisation` behavior
        virtualisation.isVmVariant = lib.mkOverride 0 true;
      };
    };

  };

  # uses extendModules
  meta.buildDocsInSandbox = false;
}
