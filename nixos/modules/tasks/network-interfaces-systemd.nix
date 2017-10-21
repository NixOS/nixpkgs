{ config, lib, pkgs, utils, ... }:

with utils;
with lib;

let

  cfg = config.networking;
  interfaces = attrValues cfg.interfaces;

  interfaceIps = i:
    i.ip4 ++ optionals cfg.enableIPv6 i.ip6
    ++ optional (i.ipAddress != null) {
      address = i.ipAddress;
      prefixLength = i.prefixLength;
    } ++ optional (cfg.enableIPv6 && i.ipv6Address != null) {
      address = i.ipv6Address;
      prefixLength = i.ipv6PrefixLength;
    };

  dhcpStr = useDHCP: if useDHCP == true || useDHCP == null then "both" else "none";

  slaves =
    concatLists (map (bond: bond.interfaces) (attrValues cfg.bonds))
    ++ concatLists (map (bridge: bridge.interfaces) (attrValues cfg.bridges))
    ++ map (sit: sit.dev) (attrValues cfg.sits)
    ++ map (vlan: vlan.interface) (attrValues cfg.vlans);

in

{

  config = mkIf cfg.useNetworkd {

    assertions = [ {
      assertion = cfg.defaultGatewayWindowSize == null;
      message = "networking.defaultGatewayWindowSize is not supported by networkd.";
    } {
      assertion = cfg.vswitches == {};
      message = "networking.vswichtes are not supported by networkd.";
    } {
      assertion = cfg.defaultGateway == null || cfg.defaultGateway.interface == null;
      message = "networking.defaultGateway.interface is not supported by networkd.";
    } {
      assertion = cfg.defaultGateway6 == null || cfg.defaultGateway6.interface == null;
      message = "networking.defaultGateway6.interface is not supported by networkd.";
    } ] ++ flip mapAttrsToList cfg.bridges (n: { rstp, ... }: {
      assertion = !rstp;
      message = "networking.bridges.${n}.rstp is not supported by networkd.";
    });

    networking.dhcpcd.enable = mkDefault false;

    systemd.services.network-local-commands = {
      after = [ "systemd-networkd.service" ];
      bindsTo = [ "systemd-networkd.service" ];
    };

    systemd.network =
      let
        domains = cfg.search ++ (optional (cfg.domain != null) cfg.domain);
        genericNetwork = override:
          let gateway = optional (cfg.defaultGateway != null) cfg.defaultGateway.address
            ++ optional (cfg.defaultGateway6 != null) cfg.defaultGateway6.address;
          in {
            DHCP = override (dhcpStr cfg.useDHCP);
          } // optionalAttrs (gateway != [ ]) {
            gateway = override gateway;
          } // optionalAttrs (domains != [ ]) {
            domains = override domains;
          };
      in mkMerge [ {
        enable = true;
        networks."99-main" = genericNetwork mkDefault;
      }
      (mkMerge (flip map interfaces (i: {
        netdevs = mkIf i.virtual (
          let
            devType = if i.virtualType != null then i.virtualType
              else (if hasPrefix "tun" i.name then "tun" else "tap");
          in {
            "40-${i.name}" = {
              netdevConfig = {
                Name = i.name;
                Kind = devType;
              };
              "${devType}Config" = optionalAttrs (i.virtualOwner != null) {
                User = i.virtualOwner;
              };
            };
          });
        networks."40-${i.name}" = mkMerge [ (genericNetwork mkDefault) {
          name = mkDefault i.name;
          DHCP = mkForce (dhcpStr
            (if i.useDHCP != null then i.useDHCP else cfg.useDHCP && interfaceIps i == [ ]));
          address = flip map (interfaceIps i)
            (ip: "${ip.address}/${toString ip.prefixLength}");
        } ];
      })))
      (mkMerge (flip mapAttrsToList cfg.bridges (name: bridge: {
        netdevs."40-${name}" = {
          netdevConfig = {
            Name = name;
            Kind = "bridge";
          };
        };
        networks = listToAttrs (flip map bridge.interfaces (bi:
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
                                     any (kOpt: do ? "${kOpt}") kOpts.optNames);
            # build final set of systemd options to bond values
            buildOptionSet = mapAttrs (_: kOpts: with kOpts;
                               # we simply take the first set kernel bond option
                               # (one option has multiple names, which is silly)
                               head (map (optN: valTransform (do."${optN}"))
                                 # only map those that exist
                                 (filter (o: do ? "${o}") optNames)));
            in seq assertNoUnknownOption
                   (buildOptionSet (filterSystemdOptions driverOptionMapping));

        };

        networks = listToAttrs (flip map bond.interfaces (bi:
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

  };

}
