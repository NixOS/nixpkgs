{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.boot.initrd.network;

  dhcpinterfaces = lib.attrNames (lib.filterAttrs (iface: v: v.useDHCP == true) (config.networking.interfaces or {}));

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
          for i in $dns; do
            echo "nameserver $dns" >> /etc/resolv.conf
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
        configured using the <literal>ip</literal> kernel parameter,
        as described in <link
        xlink:href="https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt">the
        kernel documentation</link>.  Otherwise, if
        <option>networking.useDHCP</option> is enabled, an IP address
        is acquired using DHCP.

        You should add the module(s) required for your network card to
        boot.initrd.availableKernelModules.
        <literal>lspci -v | grep -iA8 'network\|ethernet'</literal>
        will tell you which.
      '';
    };

    boot.initrd.network.udhcpc.extraArgs = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        Additional command-line arguments passed verbatim to udhcpc if
        <option>boot.initrd.network.enable</option> and <option>networking.useDHCP</option>
        are enabled.
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

    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.mkinitcpio-nfs-utils}/bin/ipconfig
    '';

    boot.initrd.preLVMCommands = mkBefore (
      # Search for interface definitions in command line.
      ''
        for o in $(cat /proc/cmdline); do
          case $o in
            ip=*)
              ipconfig $o && hasNetwork=1
              ;;
          esac
        done
      ''

      # Otherwise, use DHCP.
      + optionalString (config.networking.useDHCP || dhcpinterfaces != []) ''
        if [ -z "$hasNetwork" ]; then

          # Bring up all interfaces.
          for iface in $(ls /sys/class/net/); do
            echo "bringing up network interface $iface..."
            ip link set "$iface" up
          done

          # Acquire DHCP leases.
          for iface in ${ if config.networking.useDHCP then
                            "$(ls /sys/class/net/ | grep -v ^lo$)"
                          else
                            lib.concatMapStringsSep " " lib.escapeShellArg dhcpinterfaces
                        }; do
            echo "acquiring IP address via DHCP on $iface..."
            udhcpc --quit --now -i $iface -O staticroutes --script ${udhcpcScript} ${udhcpcArgs} && hasNetwork=1
          done
        fi
      ''

      + ''
        if [ -n "$hasNetwork" ]; then
          echo "networking is up!"
          ${cfg.postCommands}
        fi
      '');

  };

}
