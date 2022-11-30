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
      default = true;
      description = lib.mdDoc ''
        Whether to clear the configuration of the interfaces that were set up in
        the initrd right before stage 2 takes over. Stage 2 will do the regular network
        configuration based on the NixOS networking options.
      '';
    };

    boot.initrd.network.udhcpc.extraArgs = mkOption {
      default = [];
      type = types.listOf types.str;
      description = lib.mdDoc ''
        Additional command-line arguments passed verbatim to udhcpc if
        {option}`boot.initrd.network.enable` and {option}`networking.useDHCP`
        are enabled.
      '';
    };

    boot.initrd.network.postCommands = mkOption {
      default = "";
      type = types.lines;
      description = lib.mdDoc ''
        Shell commands to be executed after stage 1 of the
        boot has initialised the network.
      '';
    };


  };

  config = mkIf cfg.enable {

    boot.initrd.kernelModules = [ "af_packet" ];

    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.klibc}/lib/klibc/bin.static/ipconfig
    '';

    boot.initrd.preLVMCommands = mkBefore (
      # Search for interface definitions in command line.
      ''
        ifaces=""
        for o in $(cat /proc/cmdline); do
          case $o in
            ip=*)
              ipconfig $o && ifaces="$ifaces $(echo $o | cut -d: -f6)"
              ;;
          esac
        done
      ''

      # Otherwise, use DHCP.
      + optionalString doDhcp ''
        # Bring up all interfaces.
        for iface in ${dhcpIfShellExpr}; do
          echo "bringing up network interface $iface..."
          ip link set "$iface" up && ifaces="$ifaces $iface"
        done

        # Acquire DHCP leases.
        for iface in ${dhcpIfShellExpr}; do
          echo "acquiring IP address via DHCP on $iface..."
          udhcpc --quit --now -i $iface -O staticroutes --script ${udhcpcScript} ${udhcpcArgs}
        done
      ''

      + cfg.postCommands);

    boot.initrd.postMountCommands = mkIf cfg.flushBeforeStage2 ''
      for iface in $ifaces; do
        ip address flush "$iface"
        ip link set "$iface" down
      done
    '';

  };

}
