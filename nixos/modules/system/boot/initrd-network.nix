{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.boot.initrd.network;

  udhcpcScript = pkgs.writeScript "udhcp-script"
    ''
      #! /bin/sh
      if [ "$1" = bound ]; then
        ip address add "$ip/$mask" dev "$interface"
        if [ -n "$router" ]; then
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
      + optionalString config.networking.useDHCP ''
        if [ -z "$hasNetwork" ]; then

          # Bring up all interfaces.
          for iface in $(cd /sys/class/net && ls); do
            echo "bringing up network interface $iface..."
            ip link set "$iface" up
          done

          # Acquire a DHCP lease.
          echo "acquiring IP address via DHCP..."
          udhcpc --quit --now --script ${udhcpcScript} && hasNetwork=1
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
