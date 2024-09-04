{ config, options, extendModules, lib, ... }:
let

  inherit (lib)
    mkOption
    ;

  vmVariant = extendModules {
    modules = [{ virtualisation.qemuGuest.enable = true; }];
  };

  vmVariantWithBootLoader = vmVariant.extendModules {
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
  options = {

    virtualisation.vmVariant = mkOption {
      description = ''
        Machine configuration to be added for the vm script produced by `nixos-rebuild build-vm`.

        Deprecated in favour of setting options with `lib.mkIf (config.virtualisation.qemuGuest.enable)`
      '';
      inherit (vmVariant) type;
      default = {};
      visible = "shallow";
    };

    virtualisation.vmVariantWithBootLoader = mkOption {
      description = ''
        Machine configuration to be added for the vm script produced by `nixos-rebuild build-vm-with-bootloader`.

        Deprecated in favour of setting options with `lib.mkIf (config.virtualisation.qemuGuest.enable && config.virtualisation.useBootLoader)`
      '';
      inherit (vmVariantWithBootLoader) type;
      default = {};
      visible = "shallow";
    };

  };

  config = {

    warnings =
      let
        defaultPrio = (lib.mkOptionDefault { }).priority;
      in
      lib.optional (options.virtualisation.vmVariant.highestPrio != defaultPrio) ''
        virtualisation.vmVariant has been deprecated in favour of setting options with `lib.mkIf (config.virtualisation.qemuGuest.enable)`
      '' ++
      lib.optional (options.virtualisation.vmVariantWithBootLoader.highestPrio != defaultPrio) ''
        virtualisation.vmVariantWithBootLoader has been deprecated in favour of setting options with `lib.mkIf (config.virtualisation.qemuGuest.enable && config.virtualisation.useBootLoader)`
      '';

    system.build = {
      vm = lib.mkDefault config.virtualisation.vmVariant.system.build.vm;
      vmWithBootLoader = lib.mkDefault config.virtualisation.vmVariantWithBootLoader.system.build.vm;
    };

  };

  # uses extendModules
  meta.buildDocsInSandbox = false;
}
