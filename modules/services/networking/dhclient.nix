{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) nettools dhcp lib;

  # Don't start dhclient on explicitly configured interfaces or on
  # interfaces that are part of a bridge.
  ignoredInterfaces =
    map (i: i.name) (lib.filter (i: i ? ipAddress && i.ipAddress != "" ) config.networking.interfaces)
    ++ concatLists (attrValues (mapAttrs (n: v: v.interfaces) config.networking.bridges));

  stateDir = "/var/lib/dhcp"; # Don't use /var/state/dhcp; not FHS-compliant.

  dhclientExitHooks = pkgs.writeText "dhclient-exit-hooks"
    ''
      #echo "$reason" >> /tmp/dhcp-exit
      #echo "$exit_status" >> /tmp/dhcp-exit

      if test "$reason" = BOUND -o "$reason" = REBOOT; then
          # Restart ntpd.  (The "ip-up" event below will trigger the
          # restart.)  We need to restart it to make sure that it will
          # actually do something: if ntpd cannot resolve the server
          # hostnames in its config file, then it will never do
          # anything ever again ("couldn't resolve ..., giving up on
          # it"), so we silently lose time synchronisation.
          ${config.system.build.upstart}/sbin/initctl stop ntpd

          ${config.system.build.upstart}/sbin/initctl emit -n ip-up
      fi

      if test "$reason" = EXPIRE -o "$reason" = RELEASE; then
          ${config.system.build.upstart}/sbin/initctl emit -n ip-down
      fi
    '';

in

{

  ###### implementation

  config = mkIf config.networking.useDHCP {

    # dhclient barfs if /proc/net/if_inet6 doesn't exist.
    boot.kernelModules = [ "ipv6" ];

    jobs.dhclient =
      { startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        path = [ dhcp ];

        script =
          ''
            # Determine the interface on which to start dhclient.
            interfaces=

            for i in $(cd /sys/class/net && ls -d *); do
                # Only run dhclient on interfaces of type ARPHRD_ETHER
                # (1), i.e. Ethernet.  Ignore peth* devices; on Xen,
                # they're renamed physical Ethernet cards used for
                # bridging.  Likewise for vif* and tap* (Xen) and
                # virbr* and vnet* (libvirt).
                if [ "$(cat /sys/class/net/$i/type)" = 1 ]; then
                    if ! for j in ${toString ignoredInterfaces}; do echo $j; done | grep -F -x -q "$i" &&
                       ! echo "$i" | grep -x -q "peth.*\|vif.*\|tap.*\|virbr.*\|vnet.*";
		    then
                        echo "Running dhclient on $i"
                        interfaces="$interfaces $i"
                    fi
                fi
            done

            if test -z "$interfaces"; then
                echo 'No interfaces on which to start dhclient!'
                exit 1
            fi

            mkdir -m 755 -p ${stateDir}

            exec dhclient -d $interfaces -e "PATH=$PATH" -lf ${stateDir}/dhclient.leases -sf ${dhcp}/sbin/dhclient-script
          '';
      };

    environment.systemPackages = [dhcp];

    environment.etc =
      [ # Dhclient hooks for emitting ip-up/ip-down events.
        { source = dhclientExitHooks;
          target = "dhclient-exit-hooks";
        }
      ];

    powerManagement.resumeCommands =
      ''
        ${config.system.build.upstart}/sbin/restart dhclient
      '';

    networking.interfaceMonitor.commands =
      ''
        if [ "$status" = up ]; then
          ${config.system.build.upstart}/sbin/restart dhclient
        fi
      '';

  };

}
