{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.initrd.network;
in
{

  options = {

    boot.initrd.network.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Add network connectivity support to initrd. The network may be
        configured using the `ip` kernel parameter,
        as described in [the kernel documentation](https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt).

        You should add the module(s) required for your network card to
        boot.initrd.availableKernelModules.
        `lspci -v | grep -iA8 'network\|ethernet'`
        will tell you which.
      '';
    };

    boot.initrd.network.flushBeforeStage2 = mkOption {
      type = types.bool;
      default = !config.boot.initrd.systemd.enable;
      defaultText = "!config.boot.initrd.systemd.enable";
      description = lib.mdDoc ''
        Whether to clear the configuration of the interfaces that were set up in
        the initrd right before stage 2 takes over. Stage 2 will do the regular network
        configuration based on the NixOS networking options.

        The default is false when systemd is enabled in initrd,
        because the systemd-networkd documentation suggests it.
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "af_packet" ];
  };
}
