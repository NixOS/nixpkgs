{
  lib,
  config,
  pkgs,
  ...
}:
let
  # List of subnets that aren't routable on the public internet.
  # https://en.wikipedia.org/wiki/List_of_reserved_IP_addresses
  reservedSubnets = [
    "0.0.0.0/8"
    "10.0.0.0/8"
    "100.64.0.0/10"
    "127.0.0.0/8"
    "169.254.0.0/16"
    "172.16.0.0/12"
    "192.0.0.0/24"
    "192.0.2.0/24"
    "192.88.99.0/24"
    "192.168.0.0/16"
    "198.18.0.0/15"
    "198.51.100.0/24"
    "203.0.113.0/24"
    "224.0.0.0/4"
    "240.0.0.0/4"
  ];

  # Helper to build a nftables set.
  buildSet = type: flags: name: elements: ''
    set ${name} {
      type ${type}
      ${lib.optionalString (flags != [ ]) "flags ${lib.concatStringsSep "," flags}"}
      ${lib.optionalString (elements != [ ]) "elements = { ${lib.concatStringsSep "," elements} }"}
    }
  '';

  buildSubnetsSet = buildSet "ipv4_addr" [ "interval" ];

  cfg = config.networking.tor;
in
{

  meta.maintainers = with lib.maintainers; [ deade1e ];

  options = {

    networking.tor = {

      virtualAddrNetworkIPv4 = lib.mkOption {
        type = lib.types.str;
        default = "10.64.0.0/10";
        description = "The virtual address space used by Tor.";
      };

      transPort = lib.mkOption {
        type = lib.types.int;
        default = 9040;
        example = 10040;
        description = "The TransPort setting of Tor";
      };

      dnsPort = lib.mkOption {
        type = lib.types.int;
        default = 9053;
        example = 10053;
        description = "The DNSPort setting of Tor";
      };

      natPriority = lib.mkOption {
        type = lib.types.int;
        default = -100;
        description = "nftables NAT handling priority.";
      };

      filterPriority = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "nftables filter handling priority.";
      };

      client = {
        enable = lib.mkEnableOption "the routing of all traffic of the current machine through Tor. Does not act as a router for other machines. IPv6 traffic is not routed and it is dropped.";

        clearnetProxy = {
          enable = lib.mkEnableOption "a squid instance that can perform requests without being routed through Tor.";

          port = lib.mkOption {
            type = lib.types.int;
            default = 3128;
            example = 8080;
            description = "Port used for the squid proxy.";
          };

        };

        excludedDestinations = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "104.16.0.0/13" ];
          description = "Excluded destination addresses that will not be routed through Tor.";
        };

        excludedInterfaces = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of excluded interfaces. The packets that are destined to these interfaces will not be routed through Tor.";
          example = [ "wg0" ];
        };

        excludedFwMarks = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of excluded fwMarks. The packets marked with these fwMarks will not be routed through Tor.";
          example = [ "0x100" ];
        };

      };

      router = {
        enable = lib.mkEnableOption "the routing of all received traffic through Tor. Does not act as a router for the current machine. IPv6 traffic is not routed and it is dropped.";

        excludedDestinations = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "104.16.0.0/13" ];
          description = "Excluded destination addresses that will not be routed through Tor.";
        };

        excludedSources = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "192.168.1.0/24" ];
          description = "Excluded source addresses that will not be routed through Tor.";
        };

      };

    };
  };

  config = lib.mkIf (cfg.client.enable || cfg.router.enable) {

    services.tor = {
      enable = true;
      client.enable = true;

      settings = {
        DNSPort = [
          (lib.mkIf cfg.client.enable {
            addr = "127.0.0.1";
            port = cfg.dnsPort;
          })

          (lib.mkIf cfg.router.enable {
            addr = "0.0.0.0";
            port = cfg.dnsPort;
          })
        ];

        AutomapHostOnResolve = true;

        TransPort = [
          {
            addr = if cfg.router.enable then "0.0.0.0" else "127.0.0.1";
            port = cfg.transPort;
          }
        ];

        VirtualAddrNetworkIPv4 = cfg.virtualAddrNetworkIPv4;
      };

    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.router.enable [ cfg.transPort ];

    networking.firewall.allowedUDPPorts = lib.mkIf cfg.router.enable [ cfg.dnsPort ];

    # Enable squid with shutdown_lifetime set to 0, as it instead would delay service stopping.
    services.squid = lib.mkIf cfg.client.clearnetProxy.enable {
      enable = true;
      proxyAddress = "127.0.0.1";
      proxyPort = cfg.client.clearnetProxy.port;
      extraConfig = ''
        shutdown_lifetime 0 seconds;
      '';
    };

    # Wait for network so that squid picks up the right DNS information
    systemd.services.squid.after = lib.mkIf cfg.client.clearnetProxy.enable [
      "network-online.target"
    ];

    systemd.services.squid.wants = lib.mkIf cfg.client.clearnetProxy.enable [
      "network-online.target"
    ];

    networking.nftables.enable = true;

    # Patch rules before checking them as they would simply fail as both "tor"
    # and "squid" users aren't available during build.
    networking.nftables.preCheckRuleset = ''
      ${lib.getExe pkgs.gnused} --in-place 's/skuid tor/skuid 1/' ruleset.conf
      ${lib.getExe pkgs.gnused} --in-place 's/skuid squid/skuid 2/' ruleset.conf
    '';

    # Here are the nftables for the routing operations. As you may notice the
    # family is "inet" so it handles both IPv4 and IPv6, but there are no rules
    # regarding IPv6 traffic, so it gets simply dropped at the end of filter
    # chains. That's on purpose as IPv6 has not been tested.
    networking.nftables.tables = {
      tor = lib.mkIf cfg.client.enable {
        enable = true;
        family = "inet";
        content = ''

          ${buildSubnetsSet "reserved_subnets" reservedSubnets}

          ${buildSubnetsSet "excluded_destinations" cfg.client.excludedDestinations}

          ${buildSet "ifname" [ ] "excluded_ifs" cfg.client.excludedInterfaces}

          ${buildSet "mark" [ ] "excluded_marks" cfg.client.excludedFwMarks}

          chain tor_nat_output {
            type nat hook output priority ${toString cfg.natPriority}

            oifname lo return
            ip daddr 127.0.0.0/8 return
            ip6 daddr ::1/128 return

            oifname @excluded_ifs return # Do not modify any packet destined to excluded intfs
            meta mark @excluded_marks return # Do not modify any packet marked with excluded marks

            skuid tor return # Do not modify any tor packets

            # Do not modify any squid packets
            ${lib.optionalString (cfg.client.clearnetProxy.enable) "skuid squid return"}

            # Here we prioritize excludedDestinations over DNS redirection,
            # but we redirect DNS requests before allowing local addresses, as
            # most network configurations have local IP addresses as DNS servers.
            ip daddr @excluded_destinations return
            ip protocol udp udp dport 53 dnat to 127.0.0.1:${toString cfg.dnsPort} # route dns before allowing local addresses
            ip daddr @reserved_subnets ip daddr != ${cfg.virtualAddrNetworkIPv4} return

            ip protocol tcp dnat to 127.0.0.1:${toString cfg.transPort} # this rewrites the dest addr but not the interface!
          }

          chain tor_filter_output {
            # Set filterPriority and drop everything by default.
            type filter hook output priority ${toString cfg.filterPriority}; policy drop;

            ct state established,related accept

            oifname lo accept # For processes that connect to interface IPs, like 192.186.1.150 and are routed through lo
            ip daddr 127.0.0.0/8 accept # DNATed packets have ethernet intf but local addresses

            oifname @excluded_ifs accept
            meta mark @excluded_marks accept

            skuid tor accept

            ${lib.optionalString (cfg.client.clearnetProxy.enable) "skuid squid accept"}

            ip daddr @reserved_subnets accept
            ip daddr @excluded_destinations accept
          }
        '';
      };

      tor-router = lib.mkIf cfg.router.enable {
        enable = true;
        family = "inet";
        content = ''

          ${buildSubnetsSet "reserved_subnets" reservedSubnets}
          ${buildSubnetsSet "excluded_destinations" cfg.router.excludedDestinations}

          ${buildSubnetsSet "excluded_sources" cfg.router.excludedSources}

          chain tor_nat_prerouting {
            type nat hook prerouting priority ${toString cfg.natPriority}

            ip daddr @reserved_subnets ip daddr != ${cfg.virtualAddrNetworkIPv4} return
            ip saddr @excluded_sources return
            ip daddr @excluded_destinations return

            ip protocol udp udp dport 53 redirect to :${toString cfg.dnsPort}
            ip protocol tcp tcp flags syn redirect to :${toString cfg.transPort}
          }

          chain tor_filter_forward {
            type filter hook forward priority ${toString cfg.filterPriority}; policy drop

            ct state established,related accept

            ip daddr @reserved_subnets accept
            ip saddr @excluded_sources accept
            ip daddr @excluded_destinations accept
          }
        '';
      };

    };

  };

}
