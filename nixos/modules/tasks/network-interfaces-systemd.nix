{
  config,
  lib,
  utils,
  pkgs,
  ...
}:

# with utils;

let

  cfg = config.networking;
  interfaces = lib.attrValues cfg.interfaces;

  interfaceIps = i: i.ipv4.addresses ++ lib.optionals cfg.enableIPv6 i.ipv6.addresses;

  interfaceRoutes = i: i.ipv4.routes ++ lib.optionals cfg.enableIPv6 i.ipv6.routes;

  dhcpStr = useDHCP: if useDHCP == true || useDHCP == null then "yes" else "no";

  slaves =
    lib.concatLists (map (bond: bond.interfaces) (lib.attrValues cfg.bonds))
    ++ lib.concatLists (map (bridge: bridge.interfaces) (lib.attrValues cfg.bridges))
    ++ map (sit: sit.dev) (lib.attrValues cfg.sits)
    ++ map (gre: gre.dev) (lib.attrValues cfg.greTunnels)
    ++ map (vlan: vlan.interface) (lib.attrValues cfg.vlans)
    # add dependency to physical or independently created vswitch member interface
    # TODO: warn the user that any address configured on those interfaces will be useless
    ++ lib.concatMap (i: lib.attrNames (lib.filterAttrs (_: config: config.type != "internal") i.interfaces)) (
      lib.attrValues cfg.vswitches
    );

  defaultGateways = lib.mkMerge (
    lib.forEach [ cfg.defaultGateway cfg.defaultGateway6 ] (
      gateway:
      lib.optionalAttrs (gateway != null && gateway.interface != null) {
        networks."40-${gateway.interface}" = {
          matchConfig.Name = gateway.interface;
          routes = [
            (
              {
                Gateway = gateway.address;
              }
              // lib.optionalAttrs (gateway.metric != null) {
                Metric = gateway.metric;
              }
            )
          ];
        };
      }
    )
  );

  genericDhcpNetworks =
    initrd:
    lib.mkIf cfg.useDHCP {
      networks."99-ethernet-default-dhcp" = {
        matchConfig = {
          Type = "ether";
          Kind = "!*"; # physical interfaces have no kind
        };
        DHCP = "yes";
        networkConfig.IPv6PrivacyExtensions = "kernel";
      };
      networks."99-wireless-client-dhcp" = {
        matchConfig.WLANInterfaceType = "station";
        DHCP = "yes";
        networkConfig.IPv6PrivacyExtensions = "kernel";
        # We also set the route metric to one more than the default
        # of 1024, so that Ethernet is preferred if both are
        # available.
        dhcpV4Config.RouteMetric = 1025;
        ipv6AcceptRAConfig.RouteMetric = 1025;
      };
    };

  interfaceNetworks = lib.mkMerge (
    lib.forEach interfaces (i: {
      netdevs = lib.mkIf i.virtual ({
        "40-${i.name}" = {
          netdevConfig = {
            Name = i.name;
            Kind = i.virtualType;
          };
          "${i.virtualType}Config" = lib.optionalAttrs (i.virtualOwner != null) {
            User = i.virtualOwner;
          };
        };
      });
      networks."40-${i.name}" = {
        name = lib.mkDefault i.name;
        DHCP = lib.mkForce (
          dhcpStr (
            if i.useDHCP != null then i.useDHCP else (config.networking.useDHCP && i.ipv4.addresses == [ ])
          )
        );
        address = lib.forEach (interfaceIps i) (ip: "${ip.address}/${toString ip.prefixLength}");
        routes = lib.forEach (interfaceRoutes i) (
          route:
          lib.mkMerge [
            # Most of these route options have not been tested.
            # Please fix or report any mistakes you may find.
            (lib.mkIf (route.address != null && route.prefixLength != null) {
              Destination = "${route.address}/${toString route.prefixLength}";
            })
            (lib.mkIf (route.options ? fastopen_no_cookie) {
              FastOpenNoCookie = route.options.fastopen_no_cookie;
            })
            (lib.mkIf (route.via != null) {
              Gateway = route.via;
            })
            (lib.mkIf (route.type != null) {
              Type = route.type;
            })
            (lib.mkIf (route.options ? onlink) {
              GatewayOnLink = true;
            })
            (lib.mkIf (route.options ? initrwnd) {
              InitialAdvertisedReceiveWindow = route.options.initrwnd;
            })
            (lib.mkIf (route.options ? initcwnd) {
              InitialCongestionWindow = route.options.initcwnd;
            })
            (lib.mkIf (route.options ? pref) {
              IPv6Preference = route.options.pref;
            })
            (lib.mkIf (route.options ? mtu) {
              MTUBytes = route.options.mtu;
            })
            (lib.mkIf (route.options ? metric) {
              Metric = route.options.metric;
            })
            (lib.mkIf (route.options ? src) {
              PreferredSource = route.options.src;
            })
            (lib.mkIf (route.options ? protocol) {
              Protocol = route.options.protocol;
            })
            (lib.mkIf (route.options ? quickack) {
              QuickAck = route.options.quickack;
            })
            (lib.mkIf (route.options ? scope) {
              Scope = route.options.scope;
            })
            (lib.mkIf (route.options ? from) {
              Source = route.options.from;
            })
            (lib.mkIf (route.options ? table) {
              Table = route.options.table;
            })
            (lib.mkIf (route.options ? advmss) {
              TCPAdvertisedMaximumSegmentSize = route.options.advmss;
            })
            (lib.mkIf (route.options ? ttl-propagate) {
              TTLPropagate = route.options.ttl-propagate == "enabled";
            })
          ]
        );
        networkConfig.IPv6PrivacyExtensions = "kernel";
        linkConfig =
          lib.optionalAttrs (i.macAddress != null) {
            MACAddress = i.macAddress;
          }
          // lib.optionalAttrs (i.mtu != null) {
            MTUBytes = toString i.mtu;
          };
      };
    })
  );

  bridgeNetworks = lib.mkMerge (
    lib.flip lib.mapAttrsToList cfg.bridges (
      name: bridge: {
        netdevs."40-${name}" = {
          netdevConfig = {
            Name = name;
            Kind = "bridge";
          };
        };
        networks = lib.listToAttrs (
          lib.forEach bridge.interfaces (
            bi:
            lib.nameValuePair "40-${bi}" {
              DHCP = lib.mkOverride 0 (dhcpStr false);
              networkConfig.Bridge = name;
            }
          )
        );
      }
    )
  );

  vlanNetworks = lib.mkMerge (
    lib.flip lib.mapAttrsToList cfg.vlans (
      name: vlan: {
        netdevs."40-${name}" = {
          netdevConfig = {
            Name = name;
            Kind = "vlan";
          };
          vlanConfig.Id = vlan.id;
        };
        networks."40-${vlan.interface}" = {
          vlan = [ name ];
        };
      }
    )
  );

in

{
  config = lib.mkMerge [

    (lib.mkIf config.boot.initrd.network.enable {
      # Note this is if initrd.network.enable, not if
      # initrd.systemd.network.enable. By setting the latter and not the
      # former, the user retains full control over the configuration.
      boot.initrd.systemd.network = lib.mkMerge [
        defaultGateways
        (genericDhcpNetworks true)
        interfaceNetworks
        bridgeNetworks
        vlanNetworks
      ];
      boot.initrd.availableKernelModules =
        lib.optional (cfg.bridges != { }) "bridge"
        ++ lib.optional (cfg.vlans != { }) "8021q";
    })

    (lib.mkIf cfg.useNetworkd {

      assertions =
        [
          {
            assertion = cfg.defaultGatewayWindowSize == null;
            message = "networking.defaultGatewayWindowSize is not supported by networkd.";
          }
          {
            assertion = cfg.defaultGateway != null -> cfg.defaultGateway.interface != null;
            message = "networking.defaultGateway.interface is not lib.optional when using networkd.";
          }
          {
            assertion = cfg.defaultGateway6 != null -> cfg.defaultGateway6.interface != null;
            message = "networking.defaultGateway6.interface is not lib.optional when using networkd.";
          }
        ]
        ++ lib.flip lib.mapAttrsToList cfg.bridges (
          n:
          { rstp, ... }:
          {
            assertion = !rstp;
            message = "networking.bridges.${n}.rstp is not supported by networkd.";
          }
        )
        ++ lib.flip lib.mapAttrsToList cfg.fooOverUDP (
          n:
          { local, ... }:
          {
            assertion = local == null;
            message = "networking.fooOverUDP.${n}.local is not supported by networkd.";
          }
        );

      networking.dhcpcd.enable = lib.mkDefault false;

      systemd.network = lib.mkMerge [
        {
          enable = true;
        }
        defaultGateways
        (genericDhcpNetworks false)
        interfaceNetworks
        bridgeNetworks
        (lib.mkMerge (
          lib.flip lib.mapAttrsToList cfg.bonds (
            name: bond: {
              netdevs."40-${name}" = {
                netdevConfig = {
                  Name = name;
                  Kind = "bond";
                };
                bondConfig =
                  let
                    # manual mapping as of 2017-02-03
                    # man 5 systemd.netdev [BOND]
                    # to https://www.kernel.org/doc/Documentation/networking/bonding.txt
                    # driver options.
                    driverOptionMapping =
                      let
                        trans = f: optName: {
                          valTransform = f;
                          optNames = [ optName ];
                        };
                        simp = trans lib.id;
                        ms = trans (v: v + "ms");
                      in
                      {
                        Mode = simp "mode";
                        TransmitHashPolicy = simp "xmit_hash_policy";
                        LACPTransmitRate = simp "lacp_rate";
                        MIIMonitorSec = ms "miimon";
                        UpDelaySec = ms "updelay";
                        DownDelaySec = ms "downdelay";
                        LearnPacketIntervalSec = simp "lp_interval";
                        AdSelect = simp "ad_select";
                        FailOverMACPolicy = simp "fail_over_mac";
                        ARPValidate = simp "arp_validate";
                        # apparently in ms for this value?! Upstream bug?
                        ARPIntervalSec = simp "arp_interval";
                        ARPIPTargets = simp "arp_ip_target";
                        ARPAllTargets = simp "arp_all_targets";
                        PrimaryReselectPolicy = simp "primary_reselect";
                        ResendIGMP = simp "resend_igmp";
                        PacketsPerSlave = simp "packets_per_slave";
                        GratuitousARP = {
                          valTransform = lib.id;
                          optNames = [
                            "num_grat_arp"
                            "num_unsol_na"
                          ];
                        };
                        AllSlavesActive = simp "all_slaves_active";
                        MinLinks = simp "min_links";
                      };

                    do = bond.driverOptions;
                    assertNoUnknownOption =
                      let
                        knownOptions = lib.flatten (lib.mapAttrsToList (_: kOpts: kOpts.optNames) driverOptionMapping);
                        # options that apparently don’t exist in the networkd config
                        unknownOptions = [ "primary" ];
                        assertTrace = bool: msg: if bool then true else builtins.trace msg false;
                      in
                      assert lib.all (
                        driverOpt:
                        assertTrace (lib.elem driverOpt (knownOptions ++ unknownOptions))
                          "The bond.driverOption `${driverOpt}` cannot be mapped to the list of known networkd bond options. Please add it to the mapping above the assert or to `unknownOptions` should it not exist in networkd."
                      ) (lib.mapAttrsToList (k: _: k) do);
                      "";
                    # get those driverOptions that have been set
                    filterSystemdOptions = lib.filterAttrs (sysDOpt: kOpts: lib.any (kOpt: do ? ${kOpt}) kOpts.optNames);
                    # build final set of systemd options to bond values
                    buildOptionSet = lib.mapAttrs (
                      _: kOpts:
                      with kOpts;
                      # we simply take the first set kernel bond option
                      # (one option has multiple names, which is silly)
                      head (
                        map (optN: valTransform (do.${optN}))
                          # only map those that exist
                          (filter (o: do ? ${o}) optNames)
                      )
                    );
                  in
                  lib.seq assertNoUnknownOption (buildOptionSet (filterSystemdOptions driverOptionMapping));

              };

              networks = lib.listToAttrs (
                lib.forEach bond.interfaces (
                  bi:
                  lib.nameValuePair "40-${bi}" {
                    DHCP = lib.mkOverride 0 (dhcpStr false);
                    networkConfig.Bond = name;
                  }
                )
              );
            }
          )
        ))
        (lib.mkMerge (
          lib.flip lib.mapAttrsToList cfg.macvlans (
            name: macvlan: {
              netdevs."40-${name}" = {
                netdevConfig = {
                  Name = name;
                  Kind = "macvlan";
                };
                macvlanConfig = lib.optionalAttrs (macvlan.mode != null) { Mode = macvlan.mode; };
              };
              networks."40-${macvlan.interface}" = {
                macvlan = [ name ];
              };
            }
          )
        ))
        (lib.mkMerge (
          lib.flip lib.mapAttrsToList cfg.fooOverUDP (
            name: fou: {
              netdevs."40-${name}" = {
                netdevConfig = {
                  Name = name;
                  Kind = "fou";
                };
                # unfortunately networkd cannot encode dependencies of netdevs on addresses/routes,
                # so we cannot specify Local=, Peer=, PeerPort=. this looks like a missing feature
                # in networkd.
                fooOverUDPConfig =
                  {
                    Port = fou.port;
                    Encapsulation = if fou.protocol != null then "FooOverUDP" else "GenericUDPEncapsulation";
                  }
                  // (lib.optionalAttrs (fou.protocol != null) {
                    Protocol = fou.protocol;
                  });
              };
            }
          )
        ))
        (lib.mkMerge (
          lib.flip lib.mapAttrsToList cfg.sits (
            name: sit: {
              netdevs."40-${name}" = {
                netdevConfig = {
                  Name = name;
                  Kind = "sit";
                };
                tunnelConfig =
                  (lib.optionalAttrs (sit.remote != null) {
                    Remote = sit.remote;
                  })
                  // (lib.optionalAttrs (sit.local != null) {
                    Local = sit.local;
                  })
                  // (lib.optionalAttrs (sit.ttl != null) {
                    TTL = sit.ttl;
                  })
                  // (lib.optionalAttrs (sit.encapsulation != null) (
                    {
                      FooOverUDP = true;
                      Encapsulation = if sit.encapsulation.type == "fou" then "FooOverUDP" else "GenericUDPEncapsulation";
                      FOUDestinationPort = sit.encapsulation.port;
                    }
                    // (lib.optionalAttrs (sit.encapsulation.sourcePort != null) {
                      FOUSourcePort = sit.encapsulation.sourcePort;
                    })
                  ));
              };
              networks = lib.mkIf (sit.dev != null) {
                "40-${sit.dev}" = {
                  tunnel = [ name ];
                };
              };
            }
          )
        ))
        (lib.mkMerge (
          lib.flip lib.mapAttrsToList cfg.greTunnels (
            name: gre: {
              netdevs."40-${name}" = {
                netdevConfig = {
                  Name = name;
                  Kind = gre.type;
                };
                tunnelConfig =
                  (lib.optionalAttrs (gre.remote != null) {
                    Remote = gre.remote;
                  })
                  // (lib.optionalAttrs (gre.local != null) {
                    Local = gre.local;
                  })
                  // (lib.optionalAttrs (gre.ttl != null) {
                    TTL = gre.ttl;
                  });
              };
              networks = lib.mkIf (gre.dev != null) {
                "40-${gre.dev}" = {
                  tunnel = [ name ];
                };
              };
            }
          )
        ))
        vlanNetworks
      ];

      # We need to prefill the slaved devices with networking options
      # This forces the network interface creator to initialize slaves.
      networking.interfaces = lib.listToAttrs (map (i: lib.nameValuePair i { }) slaves);

      systemd.services =
        let
          # We must escape interfaces due to the systemd interpretation
          subsystemDevice = interface: "sys-subsystem-net-devices-${utils.escapeSystemdPath interface}.device";
          # support for creating openvswitch switches
          createVswitchDevice =
            n: v:
            lib.nameValuePair "${n}-netdev" (
              let
                deps = map subsystemDevice (
                  lib.attrNames (lib.filterAttrs (_: config: config.type != "internal") v.interfaces)
                );
                ofRules = pkgs.writeText "vswitch-${n}-openFlowRules" v.openFlowRules;
              in
              {
                description = "Open vSwitch Interface ${n}";
                wantedBy = [
                  "network.target"
                  (subsystemDevice n)
                ];
                # and create bridge before systemd-networkd starts because it might create internal interfaces
                before = [ "systemd-networkd.service" ];
                # shutdown the bridge when network is shutdown
                partOf = [ "network.target" ];
                # requires ovs-vswitchd to be alive at all times
                bindsTo = [ "ovs-vswitchd.service" ];
                # start switch after physical interfaces and vswitch daemon
                after = [
                  "network-pre.target"
                  "ovs-vswitchd.service"
                ] ++ deps;
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
                            -- set bridge ${n} protocols=${lib.concatStringsSep "," v.supportedOpenFlowVersions}
                '';
                script = ''
                  echo "Configuring Open vSwitch ${n}..."
                  ovs-vsctl ${
                    lib.concatStrings (
                      lib.mapAttrsToList (
                        name: config:
                        " -- add-port ${n} ${name}" + lib.optionalString (config.vlan != null) " tag=${toString config.vlan}"
                      ) v.interfaces
                    )
                  } \
                    ${
                      lib.concatStrings (
                        lib.mapAttrsToList (
                          name: config: lib.optionalString (config.type != null) " -- set interface ${name} type=${config.type}"
                        ) v.interfaces
                      )
                    } \
                    ${lib.concatMapStrings (x: " -- set-controller ${n} " + x) v.controllers} \
                    ${lib.concatMapStrings (x: " -- " + x) (lib.splitString "\n" v.extraOvsctlCmds)}


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
        in
        lib.mapAttrs' createVswitchDevice cfg.vswitches
        // {
          "network-local-commands" = {
            after = [ "systemd-networkd.service" ];
            bindsTo = [ "systemd-networkd.service" ];
          };
        };
    })

  ];
}
