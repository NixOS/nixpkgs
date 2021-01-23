{ config, lib, utils, pkgs, ... }:

with utils;
with lib;

let

  cfg = config.networking;
  interfaces = attrValues cfg.interfaces;

  interfaceIps = i:
    i.ipv4.addresses
    ++ optionals cfg.enableIPv6 i.ipv6.addresses;

  dhcpStr = useDHCP: if useDHCP == true || useDHCP == null then "yes" else "no";

  slaves =
    concatLists (map (bond: bond.interfaces) (attrValues cfg.bonds))
    ++ concatLists (map (bridge: bridge.interfaces) (attrValues cfg.bridges))
    ++ map (sit: sit.dev) (attrValues cfg.sits)
    ++ map (vlan: vlan.interface) (attrValues cfg.vlans)
    # add dependency to physical or independently created vswitch member interface
    # TODO: warn the user that any address configured on those interfaces will be useless
    ++ concatMap (i: attrNames (filterAttrs (_: config: config.type != "internal") i.interfaces)) (attrValues cfg.vswitches);

in

{

  config = mkIf cfg.useNetworkd {

    assertions = [ {
      assertion = cfg.defaultGatewayWindowSize == null;
      message = "networking.defaultGatewayWindowSize is not supported by networkd.";
    } {
      assertion = cfg.vswitches == {};
      message = "networking.vswitches are not supported by networkd.";
    } {
      assertion = cfg.defaultGateway == null || cfg.defaultGateway.interface == null;
      message = "networking.defaultGateway.interface is not supported by networkd.";
    } {
      assertion = cfg.defaultGateway6 == null || cfg.defaultGateway6.interface == null;
      message = "networking.defaultGateway6.interface is not supported by networkd.";
    } {
      assertion = cfg.useDHCP == false;
      message = ''
        networking.useDHCP is not supported by networkd.
        Please use per interface configuration and set the global option to false.
      '';
    } ] ++ flip mapAttrsToList cfg.bridges (n: { rstp, ... }: {
      assertion = !rstp;
      message = "networking.bridges.${n}.rstp is not supported by networkd.";
    });

    networking.dhcpcd.enable = mkDefault false;

    systemd.network =
      let
        domains = cfg.search ++ (optional (cfg.domain != null) cfg.domain);
        genericNetwork = override:
          let gateway = optional (cfg.defaultGateway != null && (cfg.defaultGateway.address or "") != "") cfg.defaultGateway.address
            ++ optional (cfg.defaultGateway6 != null && (cfg.defaultGateway6.address or "") != "") cfg.defaultGateway6.address;
          in optionalAttrs (gateway != [ ]) {
            routes = override [
              {
                routeConfig = {
                  Gateway = gateway;
                  GatewayOnLink = false;
                };
              }
            ];
          } // optionalAttrs (domains != [ ]) {
            domains = override domains;
          };
      in mkMerge [ {
        enable = true;
      }
      (mkMerge (forEach interfaces (i: {
        netdevs = mkIf i.virtual ({
          "40-${i.name}" = {
            netdevConfig = {
              Name = i.name;
              Kind = i.virtualType;
            };
            "${i.virtualType}Config" = optionalAttrs (i.virtualOwner != null) {
              User = i.virtualOwner;
            };
          };
        });
        networks."40-${i.name}" = mkMerge [ (genericNetwork mkDefault) {
          name = mkDefault i.name;
          DHCP = mkForce (dhcpStr
            (if i.useDHCP != null then i.useDHCP else false));
          address = forEach (interfaceIps i)
            (ip: "${ip.address}/${toString ip.prefixLength}");
          # IPv6PrivacyExtensions=kernel seems to be broken with networkd.
          # Instead of using IPv6PrivacyExtensions=kernel, configure it according to the value of
          # `tempAddress`:
          networkConfig.IPv6PrivacyExtensions = {
            # generate temporary addresses and use them by default
            "default" = true;
            # generate temporary addresses but keep using the standard EUI-64 ones by default
            "enabled" = "prefer-public";
            # completely disable temporary addresses
            "disabled" = false;
          }.${i.tempAddress};
          linkConfig = optionalAttrs (i.macAddress != null) {
            MACAddress = i.macAddress;
          } // optionalAttrs (i.mtu != null) {
            MTUBytes = toString i.mtu;
          };
        }];
      })))
      (mkMerge (flip mapAttrsToList cfg.bridges (name: bridge: {
        netdevs."40-${name}" = {
          netdevConfig = {
            Name = name;
            Kind = "bridge";
          };
        };
        networks = listToAttrs (forEach bridge.interfaces (bi:
          nameValuePair "40-${bi}" (mkMerge [ (genericNetwork (mkOverride 999)) {
            DHCP = mkOverride 0 (dhcpStr false);
            networkConfig.Bridge = name;
          } ])));
      })))
      (mkMerge (flip mapAttrsToList cfg.bonds (name: bond: {
        netdevs."40-${name}" = {
          netdevConfig = {
            Name = name;
            Kind = "bond";
          };
          bondConfig = let
            # manual mapping as of 2017-02-03
            # man 5 systemd.netdev [BOND]
            # to https://www.kernel.org/doc/Documentation/networking/bonding.txt
            # driver options.
            driverOptionMapping = let
              trans = f: optName: { valTransform = f; optNames = [optName]; };
              simp  = trans id;
              ms    = trans (v: v + "ms");
              in {
                Mode                       = simp "mode";
                TransmitHashPolicy         = simp "xmit_hash_policy";
                LACPTransmitRate           = simp "lacp_rate";
                MIIMonitorSec              = ms "miimon";
                UpDelaySec                 = ms "updelay";
                DownDelaySec               = ms "downdelay";
                LearnPacketIntervalSec     = simp "lp_interval";
                AdSelect                   = simp "ad_select";
                FailOverMACPolicy          = simp "fail_over_mac";
                ARPValidate                = simp "arp_validate";
                # apparently in ms for this value?! Upstream bug?
                ARPIntervalSec             = simp "arp_interval";
                ARPIPTargets               = simp "arp_ip_target";
                ARPAllTargets              = simp "arp_all_targets";
                PrimaryReselectPolicy      = simp "primary_reselect";
                ResendIGMP                 = simp "resend_igmp";
                PacketsPerSlave            = simp "packets_per_slave";
                GratuitousARP = { valTransform = id;
                                  optNames = [ "num_grat_arp" "num_unsol_na" ]; };
                AllSlavesActive            = simp "all_slaves_active";
                MinLinks                   = simp "min_links";
              };

            do = bond.driverOptions;
            assertNoUnknownOption = let
              knownOptions = flatten (mapAttrsToList (_: kOpts: kOpts.optNames)
                                                     driverOptionMapping);
              # options that apparently don’t exist in the networkd config
              unknownOptions = [ "primary" ];
              assertTrace = bool: msg: if bool then true else builtins.trace msg false;
              in assert all (driverOpt: assertTrace
                               (elem driverOpt (knownOptions ++ unknownOptions))
                               "The bond.driverOption `${driverOpt}` cannot be mapped to the list of known networkd bond options. Please add it to the mapping above the assert or to `unknownOptions` should it not exist in networkd.")
                            (mapAttrsToList (k: _: k) do); "";
            # get those driverOptions that have been set
            filterSystemdOptions = filterAttrs (sysDOpt: kOpts:
                                     any (kOpt: do ? ${kOpt}) kOpts.optNames);
            # build final set of systemd options to bond values
            buildOptionSet = mapAttrs (_: kOpts: with kOpts;
                               # we simply take the first set kernel bond option
                               # (one option has multiple names, which is silly)
                               head (map (optN: valTransform (do.${optN}))
                                 # only map those that exist
                                 (filter (o: do ? ${o}) optNames)));
            in seq assertNoUnknownOption
                   (buildOptionSet (filterSystemdOptions driverOptionMapping));

        };

        networks = listToAttrs (forEach bond.interfaces (bi:
          nameValuePair "40-${bi}" (mkMerge [ (genericNetwork (mkOverride 999)) {
            DHCP = mkOverride 0 (dhcpStr false);
            networkConfig.Bond = name;
          } ])));
      })))
      (mkMerge (flip mapAttrsToList cfg.macvlans (name: macvlan: {
        netdevs."40-${name}" = {
          netdevConfig = {
            Name = name;
            Kind = "macvlan";
          };
          macvlanConfig = optionalAttrs (macvlan.mode != null) { Mode = macvlan.mode; };
        };
        networks."40-${macvlan.interface}" = (mkMerge [ (genericNetwork (mkOverride 999)) {
          macvlan = [ name ];
        } ]);
      })))
      (mkMerge (flip mapAttrsToList cfg.sits (name: sit: {
        netdevs."40-${name}" = {
          netdevConfig = {
            Name = name;
            Kind = "sit";
          };
          tunnelConfig =
            (optionalAttrs (sit.remote != null) {
              Remote = sit.remote;
            }) // (optionalAttrs (sit.local != null) {
              Local = sit.local;
            }) // (optionalAttrs (sit.ttl != null) {
              TTL = sit.ttl;
            });
        };
        networks = mkIf (sit.dev != null) {
          "40-${sit.dev}" = (mkMerge [ (genericNetwork (mkOverride 999)) {
            tunnel = [ name ];
          } ]);
        };
      })))
      (mkMerge (flip mapAttrsToList cfg.vlans (name: vlan: {
        netdevs."40-${name}" = {
          netdevConfig = {
            Name = name;
            Kind = "vlan";
          };
          vlanConfig.Id = vlan.id;
        };
        networks."40-${vlan.interface}" = (mkMerge [ (genericNetwork (mkOverride 999)) {
          vlan = [ name ];
        } ]);
      })))
    ];

    # We need to prefill the slaved devices with networking options
    # This forces the network interface creator to initialize slaves.
    networking.interfaces = listToAttrs (map (i: nameValuePair i { }) slaves);

    systemd.services = let
      # We must escape interfaces due to the systemd interpretation
      subsystemDevice = interface:
        "sys-subsystem-net-devices-${escapeSystemdPath interface}.device";
      # support for creating openvswitch switches
      createVswitchDevice = n: v: nameValuePair "${n}-netdev"
          (let
            deps = map subsystemDevice (attrNames (filterAttrs (_: config: config.type != "internal") v.interfaces));
            ofRules = pkgs.writeText "vswitch-${n}-openFlowRules" v.openFlowRules;
          in
          { description = "Open vSwitch Interface ${n}";
            wantedBy = [ "network.target" (subsystemDevice n) ];
            # and create bridge before systemd-networkd starts because it might create internal interfaces
            before = [ "systemd-networkd.service" ];
            # shutdown the bridge when network is shutdown
            partOf = [ "network.target" ];
            # requires ovs-vswitchd to be alive at all times
            bindsTo = [ "ovs-vswitchd.service" ];
            # start switch after physical interfaces and vswitch daemon
            after = [ "network-pre.target" "ovs-vswitchd.service" ] ++ deps;
            wants = deps; # if one or more interface fails, the switch should continue to run
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            path = [ pkgs.iproute config.virtualisation.vswitch.package ];
            preStart = ''
              echo "Resetting Open vSwitch ${n}..."
              ovs-vsctl --if-exists del-br ${n} -- add-br ${n} \
                        -- set bridge ${n} protocols=${concatStringsSep "," v.supportedOpenFlowVersions}
            '';
            script = ''
              echo "Configuring Open vSwitch ${n}..."
              ovs-vsctl ${concatStrings (mapAttrsToList (name: config: " -- add-port ${n} ${name}" + optionalString (config.vlan != null) " tag=${toString config.vlan}") v.interfaces)} \
                ${concatStrings (mapAttrsToList (name: config: optionalString (config.type != null) " -- set interface ${name} type=${config.type}") v.interfaces)} \
                ${concatMapStrings (x: " -- set-controller ${n} " + x)  v.controllers} \
                ${concatMapStrings (x: " -- " + x) (splitString "\n" v.extraOvsctlCmds)}


              echo "Adding OpenFlow rules for Open vSwitch ${n}..."
              ovs-ofctl --protocols=${v.openFlowVersion} add-flows ${n} ${ofRules}
            '';
            postStop = ''
              echo "Cleaning Open vSwitch ${n}"
              echo "Shuting down internal ${n} interface"
              ip link set ${n} down || true
              echo "Deleting flows for ${n}"
              ovs-ofctl --protocols=${v.openFlowVersion} del-flows ${n} || true
              echo "Deleting Open vSwitch ${n}"
              ovs-vsctl --if-exists del-br ${n} || true
            '';
          });
    in mapAttrs' createVswitchDevice cfg.vswitches
      // {
            "network-local-commands" = {
              after = [ "systemd-networkd.service" ];
              bindsTo = [ "systemd-networkd.service" ];
          };
      };
  };

}
