{ config, lib, pkgs, utils, ... }:

with utils;
with lib;

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

  destroyBond = i: ''
    while true; do
      UPDATED=1
      SLAVES=$(ip link | grep 'master ${i}' | awk -F: '{print $2}')
      for I in $SLAVES; do
        UPDATED=0
        ip link set "$I" nomaster
      done
      [ "$UPDATED" -eq "1" ] && break
    done
    ip link set "${i}" down 2>/dev/null || true
    ip link del "${i}" 2>/dev/null || true
  '';

in

{

  config = mkIf (!cfg.useNetworkd) {

    systemd.services =
      let

        networkLocalCommands = {
          after = [ "network-setup.service" ];
          bindsTo = [ "network-setup.service" ];
        };

        networkSetup =
          { description = "Networking Setup";

            after = [ "network-interfaces.target" "network-pre.target" ];
            before = [ "network.target" ];
            wantedBy = [ "network.target" ];

            unitConfig.ConditionCapability = "CAP_NET_ADMIN";

            path = [ pkgs.iproute ];

            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;

            script =
              ''
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

                # Set the default gateway.
                ${optionalString (cfg.defaultGateway != null && cfg.defaultGateway != "") ''
                  # FIXME: get rid of "|| true" (necessary to make it idempotent).
                  ip route add default via "${cfg.defaultGateway}" ${
                    optionalString (cfg.defaultGatewayWindowSize != null)
                      "window ${toString cfg.defaultGatewayWindowSize}"} || true
                ''}
                ${optionalString (cfg.defaultGateway6 != null && cfg.defaultGateway6 != "") ''
                  # FIXME: get rid of "|| true" (necessary to make it idempotent).
                  ip -6 route add ::/0 via "${cfg.defaultGateway6}" ${
                    optionalString (cfg.defaultGatewayWindowSize != null)
                      "window ${toString cfg.defaultGatewayWindowSize}"} || true
                ''}
              '';
          };

        # For each interface <foo>, create a job ‘network-addresses-<foo>.service"
        # that performs static address configuration.  It has a "wants"
        # dependency on ‘<foo>.service’, which is supposed to create
        # the interface and need not exist (i.e. for hardware
        # interfaces).  It has a binds-to dependency on the actual
        # network device, so it only gets started after the interface
        # has appeared, and it's stopped when the interface
        # disappears.
        configureAddrs = i:
          let
            ips = interfaceIps i;
          in
          nameValuePair "network-addresses-${i.name}"
          { description = "Address configuration of ${i.name}";
            wantedBy = [ "network-interfaces.target" ];
            before = [ "network-interfaces.target" ];
            bindsTo = [ (subsystemDevice i.name) ];
            after = [ (subsystemDevice i.name) "network-pre.target" ];
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.iproute ];
            script =
              ''
                echo "bringing up interface..."
                ip link set "${i.name}" up

                restart_network_interfaces=false
              '' + flip concatMapStrings (ips) (ip:
                let
                  address = "${ip.address}/${toString ip.prefixLength}";
                in
                ''
                  echo "checking ip ${address}..."
                  if out=$(ip addr add "${address}" dev "${i.name}" 2>&1); then
                    echo "added ip ${address}..."
                    restart_network_setup=true
                  elif ! echo "$out" | grep "File exists" >/dev/null 2>&1; then
                    echo "failed to add ${address}"
                    exit 1
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
            preStop = flip concatMapStrings (ips) (ip:
                let
                  address = "${ip.address}/${toString ip.prefixLength}";
                in
                ''
                  echo -n "deleting ${address}..."
                  ip addr del "${address}" dev "${i.name}" >/dev/null 2>&1 || echo -n " Failed"
                  echo ""
                '');
          };

        createTunDevice = i: nameValuePair "${i.name}-netdev"
          { description = "Virtual Network Interface ${i.name}";
            requires = [ "dev-net-tun.device" ];
            after = [ "dev-net-tun.device" "network-pre.target" ];
            wantedBy = [ "network.target" (subsystemDevice i.name) ];
            before = [ "network-interfaces.target" (subsystemDevice i.name) ];
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
            bindsTo = deps ++ optional v.rstp "mstpd.service";
            partOf = optional v.rstp "mstpd.service";
            after = [ "network-pre.target" "mstpd.service" ] ++ deps
              ++ concatMap (i: [ "network-addresses-${i}.service" "network-link-${i}.service" ]) v.interfaces;
            before = [ "network-interfaces.target" (subsystemDevice n) ];
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.iproute ];
            script = ''
              # Remove Dead Interfaces
              echo "Removing old bridge ${n}..."
              ip link show "${n}" >/dev/null 2>&1 && ip link del "${n}"

              echo "Adding bridge ${n}..."
              ip link add name "${n}" type bridge

              # Enslave child interfaces
              ${flip concatMapStrings v.interfaces (i: ''
                ip link set "${i}" master "${n}"
                ip link set "${i}" up
              '')}

              # Enable stp on the interface
              ${optionalString v.rstp ''
                echo 2 >/sys/class/net/${n}/bridge/stp_state
              ''}

              ip link set "${n}" up
            '';
            postStop = ''
              ip link set "${n}" down || true
              ip link del "${n}" || true
            '';
          });

        createVswitchDevice = n: v: nameValuePair "${n}-netdev"
          (let
            deps = map subsystemDevice v.interfaces;
            ofRules = pkgs.writeText "vswitch-${n}-openFlowRules" v.openFlowRules;
          in
          { description = "Open vSwitch Interface ${n}";
            wantedBy = [ "network.target" "vswitchd.service" ] ++ deps;
            bindsTo =  [ "vswitchd.service" (subsystemDevice n) ] ++ deps;
            partOf = [ "vswitchd.service" ];
            after = [ "network-pre.target" "vswitchd.service" ] ++ deps;
            before = [ "network-interfaces.target" ];
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.iproute config.virtualisation.vswitch.package ];
            script = ''
              echo "Removing old Open vSwitch ${n}..."
              ovs-vsctl --if-exists del-br ${n}

              echo "Adding Open vSwitch ${n}..."
              ovs-vsctl -- add-br ${n} ${concatMapStrings (i: " -- add-port ${n} ${i}") v.interfaces} \
                ${concatMapStrings (x: " -- set-controller ${n} " + x)  v.controllers} \
                ${concatMapStrings (x: " -- " + x) (splitString "\n" v.extraOvsctlCmds)}

              echo "Adding OpenFlow rules for Open vSwitch ${n}..."
              ovs-ofctl add-flows ${n} ${ofRules}
            '';
            postStop = ''
              ip link set ${n} down || true
              ovs-ofctl del-flows ${n} || true
              ovs-vsctl --if-exists del-br ${n}
            '';
          });

        createBondDevice = n: v: nameValuePair "${n}-netdev"
          (let
            deps = map subsystemDevice v.interfaces;
          in
          { description = "Bond Interface ${n}";
            wantedBy = [ "network.target" (subsystemDevice n) ];
            bindsTo = deps;
            after = [ "network-pre.target" ] ++ deps
              ++ concatMap (i: [ "network-addresses-${i}.service" "network-link-${i}.service" ]) v.interfaces;
            before = [ "network-interfaces.target" (subsystemDevice n) ];
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.iproute pkgs.gawk ];
            script = ''
              echo "Destroying old bond ${n}..."
              ${destroyBond n}

              echo "Creating new bond ${n}..."
              ip link add name "${n}" type bond \
                ${optionalString (v.mode != null) "mode ${toString v.mode}"} \
                ${optionalString (v.miimon != null) "miimon ${toString v.miimon}"} \
                ${optionalString (v.xmit_hash_policy != null) "xmit_hash_policy ${toString v.xmit_hash_policy}"} \
                ${optionalString (v.lacp_rate != null) "lacp_rate ${toString v.lacp_rate}"}

              # !!! There must be a better way to wait for the interface
              while [ ! -d "/sys/class/net/${n}" ]; do sleep 0.1; done;

              # Bring up the bond and enslave the specified interfaces
              ip link set "${n}" up
              ${flip concatMapStrings v.interfaces (i: ''
                ip link set "${i}" down
                ip link set "${i}" master "${n}"
              '')}
            '';
            postStop = destroyBond n;
          });

        createMacvlanDevice = n: v: nameValuePair "${n}-netdev"
          (let
            deps = [ (subsystemDevice v.interface) ];
          in
          { description = "Vlan Interface ${n}";
            wantedBy = [ "network.target" (subsystemDevice n) ];
            bindsTo = deps;
            after = [ "network-pre.target" ] ++ deps;
            before = [ "network-interfaces.target" (subsystemDevice n) ];
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.iproute ];
            script = ''
              # Remove Dead Interfaces
              ip link show "${n}" >/dev/null 2>&1 && ip link delete "${n}"
              ip link add link "${v.interface}" name "${n}" type macvlan \
                ${optionalString (v.mode != null) "mode ${v.mode}"}
              ip link set "${n}" up
            '';
            postStop = ''
              ip link delete "${n}"
            '';
          });

        createSitDevice = n: v: nameValuePair "${n}-netdev"
          (let
            deps = optional (v.dev != null) (subsystemDevice v.dev);
          in
          { description = "6-to-4 Tunnel Interface ${n}";
            wantedBy = [ "network.target" (subsystemDevice n) ];
            bindsTo = deps;
            after = [ "network-pre.target" ] ++ deps;
            before = [ "network-interfaces.target" (subsystemDevice n) ];
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
            after = [ "network-pre.target" ] ++ deps;
            before = [ "network-interfaces.target" (subsystemDevice n) ];
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
           map configureAddrs interfaces ++
           map createTunDevice (filter (i: i.virtual) interfaces))
         // mapAttrs' createBridgeDevice cfg.bridges
         // mapAttrs' createVswitchDevice cfg.vswitches
         // mapAttrs' createBondDevice cfg.bonds
         // mapAttrs' createMacvlanDevice cfg.macvlans
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
