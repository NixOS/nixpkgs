{ config, lib, pkgs, ... }:

let
  cfg = config.services.ndppd;

  render = s: f: lib.concatStringsSep "\n" (lib.mapAttrsToList f s);
  prefer = a: b: if a != null then a else b;

  ndppdConf = prefer cfg.configFile (pkgs.writeText "ndppd.conf" ''
    route-ttl ${toString cfg.routeTTL}
    ${render cfg.proxies (proxyInterfaceName: proxy: ''
    proxy ${prefer proxy.interface proxyInterfaceName} {
      router ${lib.boolToString proxy.router}
      timeout ${toString proxy.timeout}
      ttl ${toString proxy.ttl}
      ${render proxy.rules (ruleNetworkName: rule: ''
      rule ${prefer rule.network ruleNetworkName} {
        ${rule.method}${lib.optionalString (rule.method == "iface") " ${rule.interface}"}
      }'')}
    }'')}
  '');

  proxy = lib.types.submodule {
    options = {
      interface = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          Listen for any Neighbor Solicitation messages on this interface,
          and respond to them according to a set of rules.
          Defaults to the name of the attrset.
        '';
        default = null;
      };
      router = lib.mkOption {
        type = lib.types.bool;
        description = ''
          Turns on or off the router flag for Neighbor Advertisement Messages.
        '';
        default = true;
      };
      timeout = lib.mkOption {
        type = lib.types.int;
        description = ''
          Controls how long to wait for a Neighbor Advertisement Message before
          invalidating the entry, in milliseconds.
        '';
        default = 500;
      };
      ttl = lib.mkOption {
        type = lib.types.int;
        description = ''
          Controls how long a valid or invalid entry remains in the cache, in
          milliseconds.
        '';
        default = 30000;
      };
      rules = lib.mkOption {
        type = lib.types.attrsOf rule;
        description = ''
          This is a rule that the target address is to match against. If no netmask
          is provided, /128 is assumed. You may have several rule sections, and the
          addresses may or may not overlap.
        '';
        default = {};
      };
    };
  };

  rule = lib.types.submodule {
    options = {
      network = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          This is the target address is to match against. If no netmask
          is provided, /128 is assumed. The addresses of several rules
          may or may not overlap.
          Defaults to the name of the attrset.
        '';
        default = null;
      };
      method = lib.mkOption {
        type = lib.types.enum [ "static" "iface" "auto" ];
        description = ''
          static: Immediately answer any Neighbor Solicitation Messages
            (if they match the IP rule).
          iface: Forward the Neighbor Solicitation Message through the specified
            interface and only respond if a matching Neighbor Advertisement
            Message is received.
          auto: Same as iface, but instead of manually specifying the outgoing
            interface, check for a matching route in /proc/net/ipv6_route.
        '';
        default = "auto";
      };
      interface = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Interface to use when method is iface.";
        default = null;
      };
    };
  };

in {
  options.services.ndppd = {
    enable = lib.mkEnableOption "daemon that proxies NDP (Neighbor Discovery Protocol) messages between interfaces";
    interface = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        Interface which is on link-level with router.
        (Legacy option, use services.ndppd.proxies.\<interface\>.rules.\<network\> instead)
      '';
      default = null;
      example = "eth0";
    };
    network = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        Network that we proxy.
        (Legacy option, use services.ndppd.proxies.\<interface\>.rules.\<network\> instead)
      '';
      default = null;
      example = "1111::/64";
    };
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "Path to configuration file.";
      default = null;
    };
    routeTTL = lib.mkOption {
      type = lib.types.int;
      description = ''
        This tells 'ndppd' how often to reload the route file /proc/net/ipv6_route,
        in milliseconds.
      '';
      default = 30000;
    };
    proxies = lib.mkOption {
      type = lib.types.attrsOf proxy;
      description = ''
        This sets up a listener, that will listen for any Neighbor Solicitation
        messages, and respond to them according to a set of rules.
      '';
      default = {};
      example = lib.literalExpression ''
        {
          eth0.rules."1111::/64" = {};
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.mkIf (cfg.interface != null && cfg.network != null) [ ''
      The options services.ndppd.interface and services.ndppd.network will probably be removed soon,
      please use services.ndppd.proxies.<interface>.rules.<network> instead.
    '' ];

    services.ndppd.proxies = lib.mkIf (cfg.interface != null && cfg.network != null) {
      ${cfg.interface}.rules.${cfg.network} = {};
    };

    systemd.services.ndppd = {
      description = "NDP Proxy Daemon";
      documentation = [ "man:ndppd(1)" "man:ndppd.conf(5)" ];
      after = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.ndppd}/bin/ndppd -c ${ndppdConf}";

        # Sandboxing
        CapabilityBoundingSet = "CAP_NET_RAW CAP_NET_ADMIN";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = "AF_INET6 AF_PACKET AF_NETLINK";
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };
  };
}
