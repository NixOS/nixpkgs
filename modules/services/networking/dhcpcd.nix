{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) dhcpcd;

  # Don't start dhclient on explicitly configured interfaces or on
  # interfaces that are part of a bridge.
  ignoredInterfaces =
    map (i: i.name) (filter (i: i ? ipAddress && i.ipAddress != "" ) config.networking.interfaces)
    ++ concatLists (attrValues (mapAttrs (n: v: v.interfaces) config.networking.bridges));

in

{

  ###### interface

  options = {

    networking.useDHCP = mkOption {
      default = true;
      merge = mergeEnableOption;
      description = "
        Whether to use DHCP to obtain an IP adress and other
        configuration for all network interfaces that are not manually
        configured.
      ";
    };

  };


  ###### implementation

  config = mkIf config.networking.useDHCP {

    jobs.dhcpcd =
      { startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        path = [ dhcpcd pkgs.nettools pkgs.openresolv ];

        script =
          ''
            # Determine the interface on which to start dhcpcd.
            interfaces=

            for i in $(cd /sys/class/net && ls -d *); do
                # Only run dhcpcd on interfaces of type ARPHRD_ETHER
                # (1), i.e. Ethernet.  Ignore peth* devices; on Xen,
                # they're renamed physical Ethernet cards used for
                # bridging.  Likewise for vif* and tap* (Xen) and
                # virbr* and vnet* (libvirt).
                if [ "$(cat /sys/class/net/$i/type)" = 1 ]; then
                    if ! for j in ${toString ignoredInterfaces}; do echo $j; done | grep -F -x -q "$i" &&
                       ! echo "$i" | grep -x -q "peth.*\|vif.*\|tap.*\|virbr.*\|vnet.*";
		    then
                        echo "Running dhcpcd on $i"
                        interfaces="$interfaces $i"
                    fi
                fi
            done

            if [ -z "$interfaces" ]; then
                echo 'No interfaces on which to start dhcpcd!'
                exit 1
            fi

            exec dhcpcd --nobackground --persistent $interfaces
          '';
      };

    environment.systemPackages = [ dhcpcd ];

    powerManagement.resumeCommands =
      ''
        ${config.system.build.upstart}/sbin/restart dhcpcd
      '';

    networking.interfaceMonitor.commands =
      ''
        if [ "$status" = up ]; then
          ${config.system.build.upstart}/sbin/restart dhcpcd
        fi
      '';

  };

}
