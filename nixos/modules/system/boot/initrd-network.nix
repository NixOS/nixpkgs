{
  config,
  lib,
  ...
}:

with lib;

let

  cfg = config.boot.initrd.network;

in

{

  imports = [
    (mkRemovedOptionModule [
      "boot"
      "initrd"
      "network"
      "udhcpc"
      "enable"
    ] "Scripted stage 1 has been removed.")
    (mkRemovedOptionModule [
      "boot"
      "initrd"
      "network"
      "udhcpc"
      "extraArgs"
    ] "Scripted stage 1 has been removed.")
    (mkRemovedOptionModule [
      "boot"
      "initrd"
      "network"
      "postCommands"
    ] "Scripted stage 1 has been removed.")
  ];

  options = {

    boot.initrd.network.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Add network connectivity support to initrd. The network may be
        configured using the `ip` kernel parameter,
        as described in [the kernel documentation](https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt).
        Otherwise, if
        {option}`networking.useDHCP` is enabled, an IP address
        is acquired using DHCP.

        You should add the module(s) required for your network card to
        boot.initrd.availableKernelModules.
        `lspci -v | grep -iA8 'network\|ethernet'`
        will tell you which.
      '';
    };

    boot.initrd.network.flushBeforeStage2 = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to clear the configuration of the interfaces that were set up in
        the initrd right before stage 2 takes over. Stage 2 will do the regular network
        configuration based on the NixOS networking options.
      '';
    };

  };

  config = mkIf cfg.enable {

    boot.initrd.kernelModules = [ "af_packet" ];

  };

}
