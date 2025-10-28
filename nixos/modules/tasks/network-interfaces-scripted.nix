{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

with utils;
with lib;

let

  cfg = config.networking;
  interfaces = attrValues cfg.interfaces;

  slaves =
    concatMap (i: i.interfaces) (attrValues cfg.bonds)
    ++ concatMap (i: i.interfaces) (attrValues cfg.bridges)
    ++ concatMap (i: attrNames (filterAttrs (_: config: config.type != "internal") i.interfaces)) (
      attrValues cfg.vswitches
    )
    ++ concatMap (i: [ i.interface ]) (attrValues cfg.macvlans)
    ++ concatMap (i: [ i.interface ]) (attrValues cfg.vlans);

  # We must escape interfaces due to the systemd interpretation
  subsystemDevice = interface: "sys-subsystem-net-devices-${escapeSystemdPath interface}.device";

  interfaceIps = i: i.ipv4.addresses ++ optionals cfg.enableIPv6 i.ipv6.addresses;

  destroyBond = i: ''
    while true; do
      UPDATED=1
      SLAVES=$(ip link | grep 'master ${i}' | awk -F: '{print $2}')
      for I in $SLAVES; do
        UPDATED=0
        ip link set dev "$I" nomaster
      done
      [ "$UPDATED" -eq "1" ] && break
    done
    ip link set dev "${i}" down 2>/dev/null || true
    ip link del dev "${i}" 2>/dev/null || true
  '';

  formatIpArgs =
    args:
    lib.pipe args [
      (lib.filterAttrs (n: v: v != null))
      (lib.mapAttrsToList (n: v: "${n} ${toString v}"))
      (lib.concatStringsSep " ")
    ];

  # warn that these attributes are deprecated (2017-2-2)
  # Should be removed in the release after next
  bondDeprecation = rec {
    deprecated = [
      "lacp_rate"
      "miimon"
      "mode"
      "xmit_hash_policy"
    ];
    filterDeprecated =
      bond: (filterAttrs (attrName: attr: elem attrName deprecated && attr != null) bond);
  };

  bondWarnings =
    let
      oneBondWarnings =
        bondName: bond: mapAttrsToList (bondText bondName) (bondDeprecation.filterDeprecated bond);
      bondText =
        bondName: optName: _:
        "${bondName}.${optName} is deprecated, use ${bondName}.driverOptions";
    in
    {
      warnings = flatten (mapAttrsToList oneBondWarnings cfg.bonds);
    };

  normalConfig = {
    systemd.network.links =
      let
        createNetworkLink =
          i:
          nameValuePair "40-${i.name}" {
            matchConfig.OriginalName = i.name;
            linkConfig =
              optionalAttrs (i.macAddress != null) {
                MACAddress = i.macAddress;
              }
              // optionalAttrs (i.mtu != null) {
                MTUBytes = toString i.mtu;
              };
          };
      in
      listToAttrs (map createNetworkLink interfaces);
    systemd.services =
      let

        deviceDependency =
          dev:
          # Use systemd service if we manage device creation, else
          # trust udev when not in a container
          if (dev == null || dev == "lo") then
            [ ]
          else if
            (hasAttr dev (filterAttrs (k: v: v.virtual) cfg.interfaces))
            || (hasAttr dev cfg.bridges)
            || (hasAttr dev cfg.bonds)
            || (hasAttr dev cfg.macvlans)
            || (hasAttr dev cfg.sits)
            || (hasAttr dev cfg.ipips)
            || (hasAttr dev cfg.vlans)
            || (hasAttr dev cfg.greTunnels)
            || (hasAttr dev cfg.vswitches)
          then
            [ "${dev}-netdev.service" ]
          else
            optional (!config.boot.isContainer) (subsystemDevice dev);

        hasDefaultGatewaySet =
          (cfg.defaultGateway != null && cfg.defaultGateway.address != "")
          || (cfg.enableIPv6 && cfg.defaultGateway6 != null && cfg.defaultGateway6.address != "");

        needNetworkSetup =
          cfg.resolvconf.enable || cfg.defaultGateway != null || cfg.defaultGateway6 != null;

        networkLocalCommands = lib.mkIf needNetworkSetup {
          after = [ "network-setup.service" ];
          bindsTo = [ "network-setup.service" ];
        };

        networkSetup = lib.mkIf needNetworkSetup {
          description = "Networking Setup";

          after = [ "network-pre.target" ];
          before = [
            "network.target"
            "shutdown.target"
          ];
          wants = [ "network.target" ];
          # exclude bridges from the partOf relationship to fix container networking bug #47210
          partOf = map (i: "network-addresses-${i.name}.service") (
            filter (i: !(hasAttr i.name cfg.bridges)) interfaces
          );
          conflicts = [ "shutdown.target" ];
          wantedBy = [ "multi-user.target" ] ++ optional hasDefaultGatewaySet "network-online.target";

          unitConfig.ConditionCapability = "CAP_NET_ADMIN";

          path = [ pkgs.iproute2 ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };

          unitConfig.DefaultDependencies = false;

          script = ''
            ${optionalString config.networking.resolvconf.enable ''
              # Set the static DNS configuration, if given.
              ${pkgs.openresolv}/sbin/resolvconf -m 1 -a static <<EOF
              ${optionalString (cfg.nameservers != [ ] && cfg.domain != null) ''
                domain ${cfg.domain}
              ''}
              ${optionalString (cfg.search != [ ]) ("search " + concatStringsSep " " cfg.search)}
              ${flip concatMapStrings cfg.nameservers (ns: ''
                nameserver ${ns}
              '')}
              EOF
            ''}

            # Set the default gateway
            ${flip concatMapStrings
              [
                {
                  version = "-4";
                  gateway = cfg.defaultGateway;
                }
                {
                  version = "-6";
                  gateway = cfg.defaultGateway6;
                }
              ]
              (
                { version, gateway }:
                optionalString (gateway != null && gateway.address != "") ''
                  ${optionalString (gateway.interface != null) ''
                    ip ${version} route replace ${gateway.address} proto static ${
                      formatIpArgs {
                        metric = gateway.metric;
                        dev = gateway.interface;
                      }
                    }
                  ''}
                  ip ${version} route replace default proto static ${
                    formatIpArgs {
                      metric = gateway.metric;
                      via = gateway.address;
                      window = cfg.defaultGatewayWindowSize;
                      dev = gateway.interface;
                      src = gateway.source;
                    }
                  }
                ''
              )
            }
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
        configureAddrs =
          i:
          let
            ips = interfaceIps i;
          in
          nameValuePair "network-addresses-${i.name}" {
            description = "Address configuration of ${i.name}";
            wantedBy = [
              "network-setup.service"
              "network.target"
            ];
            # order before network-setup because the routes that are configured
            # there may need ip addresses configured
            before = [ "network-setup.service" ];
            bindsTo = deviceDependency i.name;
            after = [ "network-pre.target" ] ++ (deviceDependency i.name);
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            # Restart rather than stop+start this unit to prevent the
            # network from dying during switch-to-configuration.
            stopIfChanged = false;
            path = [ pkgs.iproute2 ];
            script = ''
              state="/run/nixos/network/addresses/${i.name}"
              mkdir -p "$(dirname "$state")"

              ip link set dev "${i.name}" up

              ${flip concatMapStrings ips (
                ip:
                let
                  cidr = "${ip.address}/${toString ip.prefixLength}";
                in
                ''
                  echo "${cidr}" >> $state
                  echo -n "adding address ${cidr}... "
                  if out=$(ip addr replace "${cidr}" dev "${i.name}" nodad 2>&1); then
                    echo "done"
                  else
                    echo "'ip addr replace \"${cidr}\" dev \"${i.name}\"' nodad failed: $out"
                    exit 1
                  fi
                ''
              )}

              state="/run/nixos/network/routes/${i.name}"
              mkdir -p "$(dirname "$state")"

              ${flip concatMapStrings (i.ipv4.routes ++ i.ipv6.routes) (
                route:
                let
                  cidr = "${route.address}/${toString route.prefixLength}";
                  via = optionalString (route.via != null) ''via "${route.via}"'';
                  options = concatStrings (mapAttrsToList (name: val: "${name} ${val} ") route.options);
                  type = toString route.type;
                in
                ''
                  echo "${cidr}" >> $state
                  echo -n "adding route ${cidr}... "
                  if out=$(ip route add ${type} "${cidr}" ${options} ${via} dev "${i.name}" proto static 2>&1); then
                    echo "done"
                  elif ! echo "$out" | grep "File exists" >/dev/null 2>&1; then
                    echo "'ip route add ${type} \"${cidr}\" ${options} ${via} dev \"${i.name}\"' failed: $out"
                    exit 1
                  fi
                ''
              )}
            '';
            preStop = ''
              state="/run/nixos/network/routes/${i.name}"
              if [ -e "$state" ]; then
                while read -r cidr; do
                  echo -n "deleting route $cidr... "
                  ip route del "$cidr" dev "${i.name}" >/dev/null 2>&1 && echo "done" || echo "failed"
                done < "$state"
                rm -f "$state"
              fi

              state="/run/nixos/network/addresses/${i.name}"
              if [ -e "$state" ]; then
                while read -r cidr; do
                  echo -n "deleting address $cidr... "
                  ip addr del "$cidr" dev "${i.name}" >/dev/null 2>&1 && echo "done" || echo "failed"
                done < "$state"
                rm -f "$state"
              fi
            '';
          };

        createTunDevice =
          i:
          nameValuePair "${i.name}-netdev" {
            description = "Virtual Network Interface ${i.name}";
            bindsTo = optional (!config.boot.isContainer) "dev-net-tun.device";
            after = optional (!config.boot.isContainer) "dev-net-tun.device" ++ [ "network-pre.target" ];
            wantedBy = [
              "network.target"
              "network-setup.service"
              (subsystemDevice i.name)
            ];
            before = [ "network-setup.service" ];
            path = [ pkgs.iproute2 ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              ip tuntap add dev "${i.name}" mode "${i.virtualType}" user "${i.virtualOwner}"
            '';
            postStop = ''
              ip link del dev ${i.name} || true
            '';
          };

        createBridgeDevice =
          n: v:
          nameValuePair "${n}-netdev" (
            let
              deps = concatLists (map deviceDependency v.interfaces);
            in
            {
              description = "Bridge Interface ${n}";
              wantedBy = [
                "network.target"
                "network-setup.service"
                (subsystemDevice n)
              ];
              bindsTo = deps ++ optional v.rstp "mstpd.service";
              partOf = [ "network-setup.service" ] ++ optional v.rstp "mstpd.service";
              after = [
                "network-pre.target"
              ]
              ++ deps
              ++ optional v.rstp "mstpd.service"
              ++ map (i: "network-addresses-${i}.service") v.interfaces;
              before = [ "network-setup.service" ];
              serviceConfig.Type = "oneshot";
              serviceConfig.RemainAfterExit = true;
              path = [ pkgs.iproute2 ];
              script = ''
                # Remove Dead Interfaces
                echo "Removing old bridge ${n}..."
                ip link show dev "${n}" >/dev/null 2>&1 && ip link del dev "${n}"

                echo "Adding bridge ${n}..."
                ip link add name "${n}" type bridge

                # Enslave child interfaces
                ${flip concatMapStrings v.interfaces (i: ''
                  ip link set dev "${i}" master "${n}"
                  ip link set dev "${i}" up
                '')}
                # Save list of enslaved interfaces
                echo "${
                  flip concatMapStrings v.interfaces (i: ''
                    ${i}
                  '')
                }" > /run/${n}.interfaces

                ${optionalString config.virtualisation.libvirtd.enable ''
                  # Enslave dynamically added interfaces which may be lost on nixos-rebuild
                  #
                  # if `libvirtd.service` is not running, do not use `virsh` which would try activate it via 'libvirtd.socket' and thus start it out-of-order.
                  # `libvirtd.service` will set up bridge interfaces when it will start normally.
                  #
                  if /run/current-system/systemd/bin/systemctl --quiet is-active 'libvirtd.service'; then
                    for uri in qemu:///system lxc:///; do
                      for dom in $(${pkgs.libvirt}/bin/virsh -c $uri list --name); do
                        ${pkgs.libvirt}/bin/virsh -c $uri dumpxml "$dom" | \
                        ${pkgs.xmlstarlet}/bin/xmlstarlet sel -t -m "//domain/devices/interface[@type='bridge'][source/@bridge='${n}'][target/@dev]" -v "concat('ip link set dev ',target/@dev,' master ',source/@bridge,';')" | \
                        ${pkgs.bash}/bin/bash
                      done
                    done
                  fi
                ''}

                # Enable stp on the interface
                ${optionalString v.rstp ''
                  echo 2 >/sys/class/net/${n}/bridge/stp_state
                ''}

                ip link set dev "${n}" up
              '';
              postStop = ''
                ip link set dev "${n}" down || true
                ip link del dev "${n}" || true
                rm -f /run/${n}.interfaces
              '';
              reload = ''
                # Un-enslave child interfaces (old list of interfaces)
                for interface in `cat /run/${n}.interfaces`; do
                  ip link set dev "$interface" nomaster up
                done

                # Enslave child interfaces (new list of interfaces)
                ${flip concatMapStrings v.interfaces (i: ''
                  ip link set dev "${i}" master "${n}"
                  ip link set dev "${i}" up
                '')}
                # Save list of enslaved interfaces
                echo "${
                  flip concatMapStrings v.interfaces (i: ''
                    ${i}
                  '')
                }" > /run/${n}.interfaces

                # (Un-)set stp on the bridge
                echo ${if v.rstp then "2" else "0"} > /sys/class/net/${n}/bridge/stp_state
              '';
              reloadIfChanged = true;
            }
          );

        createVswitchDevice =
          n: v:
          nameValuePair "${n}-netdev" (
            let
              deps = concatLists (
                map deviceDependency (attrNames (filterAttrs (_: config: config.type != "internal") v.interfaces))
              );
              internalConfigs = map (i: "network-addresses-${i}.service") (
                attrNames (filterAttrs (_: config: config.type == "internal") v.interfaces)
              );
              ofRules = pkgs.writeText "vswitch-${n}-openFlowRules" v.openFlowRules;
            in
            {
              description = "Open vSwitch Interface ${n}";
              wantedBy = [
                "network.target"
                "network-setup.service"
                (subsystemDevice n)
              ]
              ++ internalConfigs;
              # before = [ "network-setup.service" ];
              # should work without internalConfigs dependencies because address/link configuration depends
              # on the device, which is created by ovs-vswitchd with type=internal, but it does not...
              before = [ "network-setup.service" ] ++ internalConfigs;
              partOf = [ "network-setup.service" ]; # shutdown the bridge when network is shutdown
              bindsTo = [ "ovs-vswitchd.service" ]; # requires ovs-vswitchd to be alive at all times
              after = [
                "network-pre.target"
                "ovs-vswitchd.service"
              ]
              ++ deps; # start switch after physical interfaces and vswitch daemon
              wants = deps; # if one or more interface fails, the switch should continue to run
              serviceConfig.Type = "oneshot";
              serviceConfig.RemainAfterExit = true;
              path = [
                pkgs.iproute2
                config.virtualisation.vswitch.package
              ];
              preStart = ''
                echo "Resetting Open vSwitch ${n}..."
                ovs-vsctl --if-exists del-br ${n} -- add-br ${n} \
                          -- set bridge ${n} protocols=${concatStringsSep "," v.supportedOpenFlowVersions}
              '';
              script = ''
                echo "Configuring Open vSwitch ${n}..."
                ovs-vsctl ${
                  concatStrings (
                    mapAttrsToList (
                      name: config:
                      " -- add-port ${n} ${name}" + optionalString (config.vlan != null) " tag=${toString config.vlan}"
                    ) v.interfaces
                  )
                } \
                  ${
                    concatStrings (
                      mapAttrsToList (
                        name: config: optionalString (config.type != null) " -- set interface ${name} type=${config.type}"
                      ) v.interfaces
                    )
                  } \
                  ${concatMapStrings (x: " -- set-controller ${n} " + x) v.controllers} \
                  ${concatMapStrings (x: " -- " + x) (splitString "\n" v.extraOvsctlCmds)}


                echo "Adding OpenFlow rules for Open vSwitch ${n}..."
                ovs-ofctl --protocols=${v.openFlowVersion} add-flows ${n} ${ofRules}
              '';
              postStop = ''
                echo "Cleaning Open vSwitch ${n}"
                echo "Shutting down internal ${n} interface"
                ip link set dev ${n} down || true
                echo "Deleting flows for ${n}"
                ovs-ofctl --protocols=${v.openFlowVersion} del-flows ${n} || true
                echo "Deleting Open vSwitch ${n}"
                ovs-vsctl --if-exists del-br ${n} || true
              '';
            }
          );

        createBondDevice =
          n: v:
          nameValuePair "${n}-netdev" (
            let
              deps = concatLists (map deviceDependency v.interfaces);
            in
            {
              description = "Bond Interface ${n}";
              wantedBy = [
                "network.target"
                "network-setup.service"
                (subsystemDevice n)
              ];
              bindsTo = deps;
              after = [ "network-pre.target" ] ++ deps ++ map (i: "network-addresses-${i}.service") v.interfaces;
              before = [ "network-setup.service" ];
              serviceConfig.Type = "oneshot";
              serviceConfig.RemainAfterExit = true;
              path = [
                pkgs.iproute2
                pkgs.gawk
              ];
              script = ''
                echo "Destroying old bond ${n}..."
                ${destroyBond n}

                echo "Creating new bond ${n}..."
                ip link add name "${n}" type bond \
                ${
                  let
                    opts = (mapAttrs (const toString) (bondDeprecation.filterDeprecated v)) // v.driverOptions;
                  in
                  concatStringsSep "\n" (mapAttrsToList (set: val: "  ${set} ${val} \\") opts)
                }

                # !!! There must be a better way to wait for the interface
                while [ ! -d "/sys/class/net/${n}" ]; do sleep 0.1; done;

                # Bring up the bond and enslave the specified interfaces
                ip link set dev "${n}" up
                ${flip concatMapStrings v.interfaces (i: ''
                  ip link set dev "${i}" down
                  ip link set dev "${i}" master "${n}"
                '')}
              '';
              postStop = destroyBond n;
            }
          );

        createMacvlanDevice =
          n: v:
          nameValuePair "${n}-netdev" (
            let
              deps = deviceDependency v.interface;
            in
            {
              description = "MACVLAN Interface ${n}";
              wantedBy = [
                "network.target"
                "network-setup.service"
                (subsystemDevice n)
              ];
              bindsTo = deps;
              after = [ "network-pre.target" ] ++ deps;
              before = [ "network-setup.service" ];
              serviceConfig.Type = "oneshot";
              serviceConfig.RemainAfterExit = true;
              path = [ pkgs.iproute2 ];
              script = ''
                # Remove Dead Interfaces
                ip link show dev "${n}" >/dev/null 2>&1 && ip link delete dev "${n}"
                ip link add link "${v.interface}" name "${n}" type macvlan \
                  ${optionalString (v.mode != null) "mode ${v.mode}"}
                ip link set dev "${n}" up
              '';
              postStop = ''
                ip link delete dev "${n}" || true
              '';
            }
          );

        createFouEncapsulation =
          n: v:
          nameValuePair "${n}-fou-encap" (
            let
              # if we have a device to bind to we can wait for its addresses to be
              # configured, otherwise external sequencing is required.
              deps = optionals (v.local != null && v.local.dev != null) (
                deviceDependency v.local.dev ++ [ "network-addresses-${v.local.dev}.service" ]
              );
              fouSpec = "port ${toString v.port} ${
                if v.protocol != null then "ipproto ${toString v.protocol}" else "gue"
              } ${
                optionalString (v.local != null)
                  "local ${escapeShellArg v.local.address} ${
                    optionalString (v.local.dev != null) "dev ${escapeShellArg v.local.dev}"
                  }"
              }";
            in
            {
              description = "FOU endpoint ${n}";
              wantedBy = [
                "network.target"
                "network-setup.service"
                (subsystemDevice n)
              ];
              bindsTo = deps;
              after = [ "network-pre.target" ] ++ deps;
              before = [ "network-setup.service" ];
              serviceConfig.Type = "oneshot";
              serviceConfig.RemainAfterExit = true;
              path = [ pkgs.iproute2 ];
              script = ''
                # always remove previous incarnation since show can't filter
                ip fou del ${fouSpec} >/dev/null 2>&1 || true
                ip fou add ${fouSpec}
              '';
              postStop = ''
                ip fou del ${fouSpec} || true
              '';
            }
          );

        createSitDevice =
          n: v:
          nameValuePair "${n}-netdev" (
            let
              deps = deviceDependency v.dev;
            in
            {
              description = "IPv6 in IPv4 Tunnel Interface ${n}";
              wantedBy = [
                "network.target"
                "network-setup.service"
                (subsystemDevice n)
              ];
              bindsTo = deps;
              after = [ "network-pre.target" ] ++ deps;
              before = [ "network-setup.service" ];
              serviceConfig.Type = "oneshot";
              serviceConfig.RemainAfterExit = true;
              path = [ pkgs.iproute2 ];
              script = ''
                # Remove Dead Interfaces
                ip link show dev "${n}" >/dev/null 2>&1 && ip link delete dev "${n}"
                ip link add name "${n}" type sit ${
                  formatIpArgs {
                    inherit (v)
                      remote
                      local
                      ttl
                      dev
                      ;
                    encap = if v.encapsulation.type == "6in4" then null else v.encapsulation.type;
                    encap-dport = v.encapsulation.port;
                    encap-sport = v.encapsulation.sourcePort;
                  }
                }
                ip link set dev "${n}" up
              '';
              postStop = ''
                ip link delete dev "${n}" || true
              '';
            }
          );

        createIpipDevice =
          n: v:
          nameValuePair "${n}-netdev" (
            let
              deps = deviceDependency v.dev;
            in
            {
              description = "IP in IP Tunnel Interface ${n}";
              wantedBy = [
                "network.target"
                "network-setup.service"
                (subsystemDevice n)
              ];
              bindsTo = deps;
              after = [ "network-pre.target" ] ++ deps;
              before = [ "network-setup.service" ];
              serviceConfig.Type = "oneshot";
              serviceConfig.RemainAfterExit = true;
              path = [ pkgs.iproute2 ];
              script = ''
                # Remove Dead Interfaces
                ip link show dev "${n}" >/dev/null 2>&1 && ip link delete dev "${n}"
                ip tunnel add name "${n}" ${
                  formatIpArgs {
                    inherit (v)
                      remote
                      local
                      ttl
                      dev
                      ;
                    mode =
                      {
                        "4in6" = "ipip6";
                        "ipip" = "ipip";
                      }
                      .${v.encapsulation.type};
                    encaplimit = if v.encapsulation.type == "ipip" then null else v.encapsulation.limit;
                  }
                }
                ip link set dev "${n}" up
              '';
              postStop = ''
                ip link delete dev "${n}" || true
              '';
            }
          );

        createGreDevice =
          n: v:
          nameValuePair "${n}-netdev" (
            let
              deps = deviceDependency v.dev;
              ttlarg = if lib.hasPrefix "ip6" v.type then "hoplimit" else "ttl";
            in
            {
              description = "GRE Tunnel Interface ${n}";
              wantedBy = [
                "network.target"
                "network-setup.service"
                (subsystemDevice n)
              ];
              bindsTo = deps;
              after = [ "network-pre.target" ] ++ deps;
              before = [ "network-setup.service" ];
              serviceConfig.Type = "oneshot";
              serviceConfig.RemainAfterExit = true;
              path = [ pkgs.iproute2 ];
              script = ''
                # Remove Dead Interfaces
                ip link show dev "${n}" >/dev/null 2>&1 && ip link delete dev "${n}"
                ip link add name "${n}" type ${v.type} \
                  ${optionalString (v.remote != null) "remote \"${v.remote}\""} \
                  ${optionalString (v.local != null) "local \"${v.local}\""} \
                  ${optionalString (v.ttl != null) "${ttlarg} ${toString v.ttl}"} \
                  ${optionalString (v.dev != null) "dev \"${v.dev}\""}
                ip link set dev "${n}" up
              '';
              postStop = ''
                ip link delete dev "${n}" || true
              '';
            }
          );

        createVlanDevice =
          n: v:
          nameValuePair "${n}-netdev" (
            let
              deps = deviceDependency v.interface;
            in
            {
              description = "VLAN Interface ${n}";
              wantedBy = [
                "network.target"
                "network-setup.service"
                (subsystemDevice n)
              ];
              bindsTo = deps;
              partOf = [ "network-setup.service" ];
              after = [ "network-pre.target" ] ++ deps;
              before = [ "network-setup.service" ];
              serviceConfig.Type = "oneshot";
              serviceConfig.RemainAfterExit = true;
              path = [ pkgs.iproute2 ];
              script = ''
                # Remove Dead Interfaces
                ip link show dev "${n}" >/dev/null 2>&1 && ip link delete dev "${n}"
                ip link add link "${v.interface}" name "${n}" type vlan id "${toString v.id}"

                # We try to bring up the logical VLAN interface. If the master
                # interface the logical interface is dependent upon is not up yet we will
                # fail to immediately bring up the logical interface. The resulting logical
                # interface will brought up later when the master interface is up.
                ip link set dev "${n}" up || true
              '';
              postStop = ''
                ip link delete dev "${n}" || true
              '';
            }
          );

      in
      listToAttrs (
        map configureAddrs interfaces ++ map createTunDevice (filter (i: i.virtual) interfaces)
      )
      // mapAttrs' createBridgeDevice cfg.bridges
      // mapAttrs' createVswitchDevice cfg.vswitches
      // mapAttrs' createBondDevice cfg.bonds
      // mapAttrs' createMacvlanDevice cfg.macvlans
      // mapAttrs' createFouEncapsulation cfg.fooOverUDP
      // mapAttrs' createSitDevice cfg.sits
      // mapAttrs' createIpipDevice cfg.ipips
      // mapAttrs' createGreDevice cfg.greTunnels
      // mapAttrs' createVlanDevice cfg.vlans
      // {
        network-setup = networkSetup;
        network-local-commands = networkLocalCommands;
      };

    services.udev.extraRules = ''
      KERNEL=="tun", TAG+="systemd"
    '';

  };

in

{

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

  config = mkMerge [
    bondWarnings
    (mkIf (!cfg.useNetworkd) normalConfig)
    {
      # Ensure slave interfaces are brought up
      networking.interfaces = genAttrs slaves (i: { });
    }
  ];
}
