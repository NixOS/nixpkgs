{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.firewalld;
  format = pkgs.formats.keyValue { };
  inherit (lib) mkOption;
  inherit (lib.types)
    bool
    commas
    either
    enum
    nonEmptyStr
    separatedString
    submodule
    ;
in
{
  options.services.firewalld.settings = mkOption {
    description = ''
      FirewallD config file.
      See {manpage}`firewalld.conf(5)`.
    '';
    default = { };
    type = submodule {
      freeformType = format.type;
      options = {
        DefaultZone = mkOption {
          type = nonEmptyStr;
          description = "Default zone for connections.";
          default = "public";
        };
        CleanupOnExit = mkOption {
          type = bool;
          description = "Whether to clean up firewall rules when firewalld stops.";
          default = true;
        };
        CleanupModulesOnExit = mkOption {
          type = bool;
          description = "Whether to unload all firewall-related kernel modules when firewalld stops.";
          default = false;
        };
        IPv6_rpfilter = mkOption {
          type = enum [
            "strict"
            "loose"
            "strict-forward"
            "loose-forward"
            "no"
          ];
          description = ''
            Performs reverse path filtering (RPF) on IPv6 packets as per RFC 3704.

            Possible values:

            `"strict"`
            : Performs "strict" filtering as per RFC 3704.
              This check verifies that the in ingress interface is the same interface that would be used to send a packet reply to the source.
              That is, `ingress == egress`.

            `"loose"`
            : Performs "loose" filtering as per RFC 3704.
              This check only verifies that there is a route back to the source through any interface; even if it's not the same one on which the packet arrived.

            `"strict-forward"`
            : This is almost identical to "strict", but does not perform RPF for packets targeted to the host (INPUT).

            `"loose-forward"`
            : This is almost identical to "loose", but does not perform RPF for packets targeted to the host (INPUT).

            `"no"`
            : RPF is completely disabled.

            The rp_filter for IPv4 is controlled using sysctl.
          '';
          default = "strict";
        };
        IndividualCalls = mkOption {
          type = bool;
          description = ''
            Whether to use individual -restore calls to apply changes to the firewall.
            The use of individual calls increases the time that is needed to apply changes and to start the daemon, but is good for debugging as error messages are more specific.
          '';
          default = false;
        };
        LogDenied = mkOption {
          type = enum [
            "all"
            "unicast"
            "broadcast"
            "multicast"
            "off"
          ];
          description = ''
            Add logging rules right before reject and drop rules in the INPUT, FORWARD and OUTPUT chains for the default rules and also final reject and drop rules in zones for the configured link-layer packet type.
          '';
          default = "off";
        };
        FirewallBackend = mkOption {
          type = enum [
            "nftables"
            "iptables"
          ];
          description = ''
            The firewall backend implementation.
            This applies to all firewalld primitives.
            The only exception is direct and passthrough rules which always use the traditional iptables, ip6tables, and ebtables backends.

            ::: {.caution}
            The iptables backend is deprecated.
            It will be removed in a future release.
            :::
          '';
          default = "nftables";
        };
        FlushAllOnReload = mkOption {
          type = bool;
          description = "Whether to flush all runtime rules on a reload.";
          default = true;
        };
        ReloadPolicy = mkOption {
          type =
            let
              policy = enum [
                "DROP"
                "REJECT"
                "ACCEPT"
              ];
            in
            either policy commas;
          description = "The policy during reload.";
          default = "INPUT:DROP,FORWARD:DROP,OUTPUT:DROP";
        };
        RFC3964_IPv4 = mkOption {
          type = bool;
          description = ''
            Whether to filter IPv6 traffic with 6to4 destination addresses that correspond to IPv4 addresses that should not be routed over the public internet.
          '';
          default = true;
        };
        StrictForwardPorts = mkOption {
          type = bool;
          description = ''
            If enabled, the generated destination NAT (DNAT) rules will NOT accept traffic that was DNAT'd by other entities, e.g. docker.
            Firewalld will be strict and not allow published container ports until they're explicitly allowed via firewalld.
            If set to `false`, then docker (and podman) integrates seamlessly with firewalld.
            Published container ports are implicitly allowed.
          '';
          default = false;
        };
        NftablesFlowtable = mkOption {
          type = separatedString " ";
          description = ''
            This may improve forwarded traffic throughput by enabling nftables flowtable.
            It is a software fastpath and avoids calling nftables rule evaluation for data packets.
            Its value is a space separate list of interfaces.
          '';
          default = "off";
        };
        NftablesCounters = mkOption {
          type = bool;
          description = "Whether to add a counter to every nftables rule.";
          default = false;
        };
        NftablesTableOwner = mkOption {
          type = bool;
          description = ''
            If enabled, the generated nftables rule set will be owned exclusively by firewalld.
            This prevents other entities from mistakenly (or maliciously) modifying firewalld's rule set.
            If you intend to modify firewalld's rules, set this to `false`.
          '';
          default = true;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.FirewallBackend == "nftables" -> config.networking.nftables.enable;
        message = ''
          FirewallD uses nftables as the firewall backend (by default), but nftables support isn't enabled.
          Please read the description of networking.nftables.enable for possible problems.
          If using nftables is not desired, set services.firewalld.settings.FirewallBackend to "iptables", but be aware that FirewallD has deprecated support for it, and will override firewall rule set by other services, if any.
        '';
      }
    ];

    environment.etc."firewalld/firewalld.conf" = {
      source = format.generate "firewalld.conf" cfg.settings;
    };
  };
}
