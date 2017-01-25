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
        genericNetwork = override: {
          DHCP = override (dhcpStr cfg.useDHCP);
        } // optionalAttrs (cfg.defaultGateway != null) {
          gateway = override [ cfg.defaultGateway ];
        } // optionalAttrs (cfg.defaultGateway6 != null) {
          gateway = override [ cfg.defaultGateway6 ];
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
          bondConfig =
            (optionalAttrs (bond.lacp_rate != null) {
              LACPTransmitRate = bond.lacp_rate;
            }) // (optionalAttrs (bond.miimon != null) {
              MIIMonitorSec = bond.miimon;
            }) // (optionalAttrs (bond.mode != null) {
              Mode = bond.mode;
            }) // (optionalAttrs (bond.xmit_hash_policy != null) {
              TransmitHashPolicy = bond.xmit_hash_policy;
            });
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
