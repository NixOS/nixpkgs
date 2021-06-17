{ config, lib, pkgs, ...}:

with lib;
with import ./nftlib.nix {inherit lib;};
let
  cfg = config.networking.zone-firewall;

  zones = unique ((attrValues cfg.interfaces) ++ [cfg.localZone]);

  ruleMatches = situation: rule:
    let conditionMatches = cond:
          all (key: let condValue = cond.${key} or "*";
                    in
                      (elem situation.${key} condValue) ||
                      (elem "*" condValue))
            (attrNames situation);
    in
      any conditionMatches
        (if rule.conditions != null
         then rule.conditions
         else [{}]);
    
  rulesForZone = type: from: to: 
    let
      matcher = ruleMatches { inherit from to; };

      filteredRules = filter matcher (attrValues cfg.rules);
      isHairpin = 
        cfg.allowHairpin
        && (from == to)
        && (! isNull from);
      acceptRule =
        optional isHairpin
          { rule = "accept"; priority = -10000000; };

    in
      (map normalizeRule filteredRules) ++ acceptRule;

  globalRules = genAttrs ["filter" "nat"]
    (type: map normalizeRule
      (filter (rule: rule.type == type) (attrValues cfg.globalRules)));

  chainForZonePair = from: to:
      "nixos-zone-${serializedZoneName from}/${serializedZoneName to}";
  
  serializedZoneName = name:
      if isNull name 
      then "nixos-unknown"
      else name;

  filterZoneChains =
    let
      makeChain = from: to:
        nameValuePair (chainForZonePair from to) {
          rules = rulesForZone "filter" from to;
        };
      extendedZones = zones ++ [null];
    in
      listToAttrs (lists.crossLists makeChain [extendedZones extendedZones]);

  zoneListT = with types;
    coercedTo
      (nullOr str)
      lists.singleton
      (listOf (nullOr str));

  filterHookChain =
    hook: chain: {
      hook = {
        type = "filter";
        hook = hook;
        priority = 0;
        policy = cfg.policy;
      };
      
      rules = globalRules.filter ++ [
        { rule = "jump ${chain}"; priority = 0; }
      ];
    };
  
in {
  options.networking.zone-firewall = with types; {
    enable = mkOption {
      description = "Whether to use TQ's nftables-based zone firewall";
      default = false;
      type = bool;
    };

    localZone = mkOption {
      description = ''
        The zone that this machine should be considered part of.
      '';

      default = "local";
      type = str;
    };

    interfaces = mkOption {
      description = ''
        Mapping of interfaces to zones.  Each interface may be in at most one zone.
      '';
      example = ''
        {
          eth0 = "wan";
          eth1 = "lan";
          eth2 = "lan";
          eth3 = "mgmt";
        }
      '';
        
      default = {};
      type = attrsOf str;
    };

    rules = mkOption {
      description = ''
        Rules for filtering packets.

        Values are a list of rules. A rule must be an nftables filter
        string (as you might write on an "nft add rule" command line,
        just without the table or chain parameters).
      '';

      default = {};
      type = attrsOf (submodule {
        options = ruleBaseOptions // {
          type = mkOption {
            description = ''
              Rule type (nat or filter).

              NAT rules may have at most one of fromZone or toZone set.
            '';
            type = enum [ "nat" "filter" ];
            default = "filter";
          };

          conditions = mkOption {
            description = ''
              List of conditions under which the rule should apply. If
              any item in this list matches, the associated rule is
              added to the chain.
            '';
            example = [
              { from = "*"; to = "local"; }
            ];
            type = listOf (submodule {
              options = {
                from = mkOption {
                  description = ''
                    Source zone. May be one of the zones in 'interfaces',
                    the local zone, '*' for all zones, null for a packet that
                    doesn't match an existing zone, or a list of the above.
                  '';
                  default = "*";
                  type = zoneListT;
                };

                to = mkOption {
                  description = "Destination zone. See from for details";
                  default = "*";
                  type = zoneListT;
                };
              };
            });
          };
        };
      });
    };

    policy = mkOption {
      description = "What to do with unhandled packets";
      type = nullOr (enum [ "accept" "drop" ]);
      default = "drop";
    };

    globalRules = mkOption {
      description = ''
        Rules that should always be run.
      '';

      default = {};

      type = attrsOf (submodule {
        options = ruleBaseOptions // {
          priority = mkOption (priorityOption // {
            description = priorityOption.description + ''
              Zone-specific processing happens at priority 0. Negative
              priorities can be used to add postprocessing steps.
            '';
          });

          type = mkOption {
            type = enum [ "filter" "nat" ];
            description = "Type of rule";
            default = "filter";
          };
        };
      });
    };

    saneDefaults = mkOption {
      description = ''
        Enable default rules allowing outbound traffic, ICMP traffic,
        and the standard related,established jazz. You probably want
        this enabled unless you want complete control over your
        firewall.

        Equivalent to:

        globalRules = {
          sanePacketTrace = { priority = 2000; rule = "jump nixos-pkt-trace"; };
          saneRelEst = { priority = 1000; rule = "jump nixos-relest"; };
          saneICMP = { priority = 900; rule = "jump nixos-global-icmp"; };
        };

        rules.acceptFromLocal =
          { conditions = [ {from = "local"; }]; rule = "accept"; priority = -1000; };

        Note that the referenced chains always exist, and can be used even if 
      '';

      default = true;
      type = bool;
    };

    allowHairpin = mkOption {
      description = ''
        Automatically add a default accept rule from each zone to itself.
      '';
      type = bool;
      default = true;
    };
  };
  
  config = mkMerge [
    (mkIf cfg.saneDefaults {
      networking.zone-firewall = {
        globalRules = {
          sanePacketTrace = { priority = 2000; rule = "jump nixos-pkt-trace"; };
          saneRelEst = { priority = 1000; rule = "jump nixos-relest"; };
          saneICMP = { priority = 900; rule = "jump nixos-global-icmp"; };
        };

        # Default accept packets from the local zone.
        rules.acceptFromLocal = {
          conditions = [{from = cfg.localZone; }];
          rule = "accept"; priority = -1000;
        };
      };
    })
    (mkIf cfg.enable {
      networking.firewall.enable = false;

      networking.nftables.tables = {
        inet.nixos-zfw = {
          chains = filterZoneChains // {
            nixos-pkt-trace = {};
            nixos-relest.rules = [
              { rule = "ct state established,related accept"; }
              { rule = "ct state invalid drop"; }
            ];
            nixos-global-icmp.rules = [
              { rule = "ip protocol icmp accept"; }
              { rule = "ip6 nexthdr icmpv6 accept"; }
            ];

            nixos-input-zone.rules =
              let
                vmapArgs =
                  mapAttrsToList
                    (iface: zone:
                      "${iface} : goto ${chainForZonePair zone cfg.localZone}, ")
                    cfg.interfaces;
                
              in [
                {
                  rule = ["iifname vmap {" vmapArgs "}"];
                  priority = 300;
                }
                {
                  rule = "goto ${chainForZonePair null cfg.localZone}";
                  priority = 200;
                }
              ];

            nixos-output-zone.rules =
              let
                vmapArgs =
                  mapAttrsToList
                    (iface: zone:
                      "${iface} : goto ${chainForZonePair cfg.localZone zone}, ")
                    cfg.interfaces;
                
              in [
                {
                  rule = ["oifname vmap {" vmapArgs "}"];
                  priority = 300;
                }
                {
                  rule = "goto ${chainForZonePair cfg.localZone null}";
                  priority = 200;
                }
              ];

            nixos-forward-zone.rules =
              let
                ifaceList = mapAttrsToList nameValuePair cfg.interfaces;
                
                knownVmap =
                  crossLists
                    (from: to:
                      "${from.name} . ${to.name} : goto ${ chainForZonePair from.value to.value },")
                    [ifaceList ifaceList];
                unknownSourceVmap =
                  mapAttrsToList
                    (iface: zone:
                      "${iface} : goto ${chainForZonePair null zone},")
                    cfg.interfaces;
                
                unknownDestVmap =
                  mapAttrsToList
                    (iface: zone:
                      "${iface} : goto ${chainForZonePair zone null},")
                    cfg.interfaces;
              in [
                {
                  rule = [
                    "iifname . oifname vmap {" knownVmap "}"
                    "iifname vmap {" unknownDestVmap "}"
                    "oifname vmap {" unknownSourceVmap "}"
                    "goto ${chainForZonePair null null}"
                  ];
                }
              ];
                
            
            nixos-input = filterHookChain "input" "nixos-input-zone";
            nixos-output = filterHookChain "output" "nixos-output-zone";
            nixos-forward = filterHookChain "forward" "nixos-forward-zone";
          };
        };
      };
      
      assertions = [
        {
          assertion = (config.networking.firewall.enable == false);
          message = "Zone-based firewall and nix-based firewall cannot be enabled at the same time";
        }
      ];
    })
  ];
}
