{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.boot.initrd.network;

  dhcpInterfaces = lib.attrNames (lib.filterAttrs (iface: v: v.useDHCP == true) (config.networking.interfaces or {}));
  doDhcp = cfg.udhcpc.enable || dhcpInterfaces != [];
  dhcpIfShellExpr = if config.networking.useDHCP || cfg.udhcpc.enable
                      then "$(ls /sys/class/net/ | grep -v ^lo$)"
                      else lib.concatMapStringsSep " " lib.escapeShellArg dhcpInterfaces;

  udhcpcScript = pkgs.writeScript "udhcp-script"
    ''
      #! /bin/sh
      if [ "$1" = bound ]; then
        ip address add "$ip/$mask" dev "$interface"
        if [ -n "$mtu" ]; then
          ip link set mtu "$mtu" dev "$interface"
        fi
        if [ -n "$staticroutes" ]; then
          echo "$staticroutes" \
            | sed -r "s@(\S+) (\S+)@ ip route add \"\1\" via \"\2\" dev \"$interface\" ; @g" \
            | sed -r "s@ via \"0\.0\.0\.0\"@@g" \
            | /bin/sh
        fi
        if [ -n "$router" ]; then
          ip route add "$router" dev "$interface" # just in case if "$router" is not within "$ip/$mask" (e.g. Hetzner Cloud)
          ip route add default via "$router" dev "$interface"
        fi
        if [ -n "$dns" ]; then
          rm -f /etc/resolv.conf
          for server in $dns; do
            echo "nameserver $server" >> /etc/resolv.conf
          done
        fi
      fi
    '';

  udhcpcArgs = toString cfg.udhcpc.extraArgs;

in

{

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
      default = !config.boot.initrd.systemd.enable;
      defaultText = "!config.boot.initrd.systemd.enable";
      description = ''
        Whether to clear the configuration of the interfaces that were set up in
        the initrd right before stage 2 takes over. Stage 2 will do the regular network
        configuration based on the NixOS networking options.

        The default is false when systemd is enabled in initrd,
        because the systemd-networkd documentation suggests it.
      '';
    };

    boot.initrd.network.udhcpc.enable = mkOption {
      default = config.networking.useDHCP && !config.boot.initrd.systemd.enable;
      defaultText = "networking.useDHCP";
      type = types.bool;
      description = ''
        Enables the udhcpc service during stage 1 of the boot process. This
        defaults to {option}`networking.useDHCP`. Therefore, this useful if
        useDHCP is off but the initramfs should do dhcp.
      '';
    };

    boot.initrd.network.udhcpc.extraArgs = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        Additional command-line arguments passed verbatim to
        udhcpc if {option}`boot.initrd.network.enable` and
        {option}`boot.initrd.network.udhcpc.enable` are enabled.
      '';
    };

    boot.initrd.network.postCommands = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Shell commands to be executed after stage 1 of the
        boot has initialised the network.
      '';
    };


  };

  config = mkIf cfg.enable {

    boot.initrd.kernelModules = [ "af_packet" ];

    boot.initrd.extraUtilsCommands = mkIf (!config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.klibc}/lib/klibc/bin.static/ipconfig
    '';

    boot.initrd.preLVMCommands = mkIf (!config.boot.initrd.systemd.enable) (mkBefore (
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
          ip link set dev "$iface" up && ifaces="$ifaces $iface"
        done

        # Acquire DHCP leases.
        for iface in ${dhcpIfShellExpr}; do
          echo "acquiring IP address via DHCP on $iface..."
          udhcpc --quit --now -i $iface -O staticroutes --script ${udhcpcScript} ${udhcpcArgs}
        done
      ''

      + cfg.postCommands));

    boot.initrd.postMountCommands = mkIf (cfg.flushBeforeStage2 && !config.boot.initrd.systemd.enable) ''
      for iface in $ifaces; do
        ip address flush dev "$iface"
        ip link set dev "$iface" down
      done
    '';

  };

}
