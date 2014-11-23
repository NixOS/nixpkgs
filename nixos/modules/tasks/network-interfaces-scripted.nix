{ config, lib, pkgs, utils, ... }:

with lib;
with utils;

let

  cfg = config.networking;
  interfaces = attrValues cfg.interfaces;
  hasVirtuals = any (i: i.virtual) interfaces;

  # We must escape interfaces due to the systemd interpretation
  subsystemDevice = interface:
    "sys-subsystem-net-devices-${escapeSystemdPath interface}.device";

  interfaceIps = i:
    i.ip4 ++ optionals cfg.enableIPv6 i.ip6
    ++ optional (i.ipAddress != null) {
      address = i.ipAddress;
      prefixLength = i.prefixLength;
    } ++ optional (cfg.enableIPv6 && i.ipv6Address != null) {
      address = i.ipv6Address;
      prefixLength = i.ipv6PrefixLength;
    };

in

{

  config = mkIf (!cfg.useNetworkd) {

    systemd.targets."network-interfaces" =
      { description = "All Network Interfaces";
        wantedBy = [ "network.target" ];
        unitConfig.X-StopOnReconfiguration = true;
      };

    systemd.services =
      let

        networkLocalCommands = {
          after = [ "network-setup.service" ];
          bindsTo = [ "network-setup.service" ];
        };

        networkSetup =
          { description = "Networking Setup";

            after = [ "network-interfaces.target" ];
            before = [ "network.target" "network-online.target" ];
            wantedBy = [ "network.target" "network-online.target" ];

            unitConfig.ConditionCapability = "CAP_NET_ADMIN";

            path = [ pkgs.iproute ];

            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;

            script =
              (optionalString (!config.services.resolved.enable) ''
                # Set the static DNS configuration, if given.
                ${pkgs.openresolv}/sbin/resolvconf -m 1 -a static <<EOF
                ${optionalString (cfg.nameservers != [] && cfg.domain != null) ''
                  domain ${cfg.domain}
                ''}
                ${optionalString (cfg.search != []) ("search " + concatStringsSep " " cfg.search)}
                ${flip concatMapStrings cfg.nameservers (ns: ''
                  nameserver ${ns}
                '')}
                EOF
              '') + ''
                # Set the default gateway.
                ${optionalString (cfg.defaultGateway != null) ''
                  # FIXME: get rid of "|| true" (necessary to make it idempotent).
                  ip route add default via "${cfg.defaultGateway}" ${
                    optionalString (cfg.defaultGatewayWindowSize != null)
                      "window ${cfg.defaultGatewayWindowSize}"} || true
                ''}
              '';
          };

        # For each interface <foo>, create a job ‘<foo>-cfg.service"
        # that performs static configuration.  It has a "wants"
        # dependency on ‘<foo>.service’, which is supposed to create
        # the interface and need not exist (i.e. for hardware
        # interfaces).  It has a binds-to dependency on the actual
        # network device, so it only gets started after the interface
        # has appeared, and it's stopped when the interface
        # disappears.
        configureInterface = i:
          let
            ips = interfaceIps i;
          in
          nameValuePair "${i.name}-cfg"
          { description = "Configuration of ${i.name}";
            wantedBy = [ "network-interfaces.target" ];
            bindsTo = [ (subsystemDevice i.name) ];
            after = [ (subsystemDevice i.name) ];
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.iproute pkgs.gawk ];
            script =
              ''
                echo "bringing up interface..."
                ip link set "${i.name}" up
              ''
              + optionalString (i.macAddress != null)
                ''
                  echo "setting MAC address to ${i.macAddress}..."
                  ip link set "${i.name}" address "${i.macAddress}"
                ''
              + optionalString (i.mtu != null)
                ''
                  echo "setting MTU to ${toString i.mtu}..."
                  ip link set "${i.name}" mtu "${toString i.mtu}"
                ''

              # Ip Setup
              +
                ''
                  curIps=$(ip -o a show dev "${i.name}" | awk '{print $4}')
                  # Only do an add if it's necessary.  This is
                  # useful when the Nix store is accessed via this
                  # interface (e.g. in a QEMU VM test).
                  restart_network_interfaces=false
                ''
              + flip concatMapStrings (ips) (ip:
                let
                  address = "${ip.address}/${toString ip.prefixLength}";
                in
                ''
                  echo "checking ip ${address}..."
                  if ! echo "$curIps" | grep "${address}" >/dev/null 2>&1; then
                    if out=$(ip addr add "${address}" dev "${i.name}" 2>&1); then
                      echo "added ip ${address}..."
                      restart_network_setup=true
                    elif ! echo "$out" | grep "File exists" >/dev/null 2>&1; then
                      echo "failed to add ${address}"
                      exit 1
                    fi
                  fi
                '')
              + optionalString (ips != [ ])
                ''
                  if [ "$restart_network_setup" = "true" ]; then
                    # Ensure that the default gateway remains set.
                    # (Flushing this interface may have removed it.)
                    ${config.systemd.package}/bin/systemctl try-restart --no-block network-setup.service
                  fi
                  ${config.systemd.package}/bin/systemctl start ip-up.target
                '';
            preStop =
              ''
                echo "releasing configured ip's..."
              ''
              + flip concatMapStrings (ips) (ip:
                let
                  address = "${ip.address}/${toString ip.prefixLength}";
                in
                ''
                  echo -n "Deleting ${address}..."
                  ip addr del "${address}" dev "${i.name}" >/dev/null 2>&1 || echo -n " Failed"
                  echo ""
                '');
          };

        createTunDevice = i: nameValuePair "${i.name}-netdev"
          { description = "Virtual Network Interface ${i.name}";
            requires = [ "dev-net-tun.device" ];
            after = [ "dev-net-tun.device" ];
            wantedBy = [ "network.target" (subsystemDevice i.name) ];
            path = [ pkgs.iproute ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              ip tuntap add dev "${i.name}" \
              ${optionalString (i.virtualType != null) "mode ${i.virtualType}"} \
              user "${i.virtualOwner}"
            '';
            postStop = ''
              ip link del ${i.name}
            '';
          };

        createBridgeDevice = n: v: nameValuePair "${n}-netdev"
          (let
            deps = map subsystemDevice v.interfaces;
          in
          { description = "Bridge Interface ${n}";
            wantedBy = [ "network.target" (subsystemDevice n) ];
            bindsTo = deps;
            after = deps;
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.bridge_utils pkgs.iproute ];
            script =
              ''
                # Remove Dead Interfaces
                ip link show "${n}" >/dev/null 2>&1 && ip link delete "${n}"

                brctl addbr "${n}"

                # Set bridge's hello time to 0 to avoid startup delays.
                brctl setfd "${n}" 0

                ${flip concatMapStrings v.interfaces (i: ''
                  brctl addif "${n}" "${i}"
                  ip link set "${i}" up
                  ip addr flush dev "${i}"

                  echo "bringing up network device ${n}..."
                  ip link set "${n}" up
                '')}

                # !!! Should delete (brctl delif) any interfaces that
                # no longer belong to the bridge.
              '';
            postStop =
              ''
                ip link set "${n}" down
                brctl delbr "${n}"
              '';
          });

        createBondDevice = n: v: nameValuePair "${n}-netdev"
          (let
            deps = map subsystemDevice v.interfaces;
          in
          { description = "Bond Interface ${n}";
            wantedBy = [ "network.target" (subsystemDevice n) ];
            bindsTo = deps;
            after = deps;
            before = [ "${n}-cfg.service" ];
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.ifenslave pkgs.iproute ];
            script = ''
              ip link add name "${n}" type bond

              # !!! There must be a better way to wait for the interface
              while [ ! -d /sys/class/net/${n} ]; do sleep 0.1; done;

              # Ensure the link is down so that we can set options
              ip link set "${n}" down

              # Set the miimon and mode options
              ${optionalString (v.miimon != null)
                "echo \"${toString v.miimon}\" >/sys/class/net/${n}/bonding/miimon"}
              ${optionalString (v.mode != null)
                "echo \"${v.mode}\" >/sys/class/net/${n}/bonding/mode"}
              ${optionalString (v.lacp_rate != null)
                "echo \"${v.lacp_rate}\" >/sys/class/net/${n}/bonding/lacp_rate"}
              ${optionalString (v.xmit_hash_policy != null)
                "echo \"${v.xmit_hash_policy}\" >/sys/class/net/${n}/bonding/xmit_hash_policy"}

              # Bring up the bond and enslave the specified interfaces
              ip link set "${n}" up
              ${flip concatMapStrings v.interfaces (i: ''
                ifenslave "${n}" "${i}"
              '')}
            '';
            postStop = ''
              ${flip concatMapStrings v.interfaces (i: ''
                ifenslave -d "${n}" "${i}" >/dev/null 2>&1 || true
              '')}
              ip link set "${n}" down >/dev/null 2>&1 || true
              ip link del "${n}" >/dev/null 2>&1 || true
            '';
          });

        createSitDevice = n: v: nameValuePair "${n}-netdev"
          (let
            deps = optional (v.dev != null) (subsystemDevice v.dev);
          in
          { description = "6-to-4 Tunnel Interface ${n}";
            wantedBy = [ "network.target" (subsystemDevice n) ];
            bindsTo = deps;
            after = deps;
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.iproute ];
            script = ''
              # Remove Dead Interfaces
              ip link show "${n}" >/dev/null 2>&1 && ip link delete "${n}"
              ip link add name "${n}" type sit \
                ${optionalString (v.remote != null) "remote \"${v.remote}\""} \
                ${optionalString (v.local != null) "local \"${v.local}\""} \
                ${optionalString (v.ttl != null) "ttl ${toString v.ttl}"} \
                ${optionalString (v.dev != null) "dev \"${v.dev}\""}
              ip link set "${n}" up
            '';
            postStop = ''
              ip link delete "${n}"
            '';
          });

        createVlanDevice = n: v: nameValuePair "${n}-netdev"
          (let
            deps = [ (subsystemDevice v.interface) ];
          in
          { description = "Vlan Interface ${n}";
            wantedBy = [ "network.target" (subsystemDevice n) ];
            bindsTo = deps;
            after = deps;
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.iproute ];
            script = ''
              # Remove Dead Interfaces
              ip link show "${n}" >/dev/null 2>&1 && ip link delete "${n}"
              ip link add link "${v.interface}" name "${n}" type vlan id "${toString v.id}"
              ip link set "${n}" up
            '';
            postStop = ''
              ip link delete "${n}"
            '';
          });

      in listToAttrs (
           map configureInterface interfaces ++
           map createTunDevice (filter (i: i.virtual) interfaces))
         // mapAttrs' createBridgeDevice cfg.bridges
         // mapAttrs' createBondDevice cfg.bonds
         // mapAttrs' createSitDevice cfg.sits
         // mapAttrs' createVlanDevice cfg.vlans
         // {
           "network-setup" = networkSetup;
           "network-local-commands" = networkLocalCommands;
         };

    services.udev.extraRules =
      ''
        KERNEL=="tun", TAG+="systemd"
      '';

  };

}
