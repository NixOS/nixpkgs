{ lib, config, ... }:
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

in
{

  meta.maintainers = with lib.maintainers; [ deade1e ];

  options = {

    networking.tor = {

      VirtualAddrNetworkIPv4 = lib.mkOption {
        type = lib.types.str;
        default = "10.64.0.0/10";
        description = "The virtual address space used by Tor.";
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
        enable = lib.mkEnableOption "the routing of all traffic of the current machine through Tor. Does not act as a router for other machines.";

        clearnetProxy = {
          enable = lib.mkEnableOption "a squid instance that can perform requests without being routed through Tor.";

          port = lib.mkOption {
            type = lib.types.int;
            default = 3128;
            example = 8080;
            description = "Port used for the squid proxy.";
          };

        };

        allowedDestinations = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "104.16.0.0/13" ];
          description = "Allowed destination addresses that will not be routed through Tor.";
        };

        allowedInterfaces = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of allowed interfaces. The packets that are destined to these interfaces will not be routed through Tor.";
          example = [ "wg0" ];
        };

        allowedFwMarks = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of allowed fwMarks. The packets marked with these fwMarks will not be routed through Tor.";
          example = [ "0x100" ];
        };

      };

      router = {
        enable = lib.mkEnableOption "the routing of all received traffic through Tor. Does not act as a router for the current machine.";

        allowedDestinations = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "104.16.0.0/13" ];
          description = "Allowed destination addresses that will not be routed through Tor.";
        };

        allowedSources = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "192.168.1.0/24" ];
          description = "Allowed source addresses that will not be routed through Tor.";
        };

      };

    };
  };

  config = {

    services.tor =
      lib.mkIf (config.networking.tor.client.enable || config.networking.tor.router.enable)
        {
          enable = true;

          client = {
            enable = true;
            transparentProxy.enable = true;
            dns.enable = true;
          };

          settings = {

            # If router option is enabled then bind to 0.0.0.0 instead of 127.0.0.1.
            DNSPort = lib.mkIf config.networking.tor.router.enable [
              {
                addr = "0.0.0.0";
                port = 9053;
              }
            ];

            # Without mkForce it sets addr to 127.0.0.1 and later it cannot bind again as 0.0.0.0.
            TransPort = lib.mkIf config.networking.tor.router.enable (
              lib.mkForce [
                {
                  addr = "0.0.0.0";
                  port = 9040;
                }
              ]
            );

            VirtualAddrNetworkIPv4 = config.networking.tor.VirtualAddrNetworkIPv4;
          };

        };

    # Open ports on firewall.
    networking.firewall.allowedTCPPorts = lib.mkIf config.networking.tor.router.enable [ 9040 ];

    networking.firewall.allowedUDPPorts = lib.mkIf config.networking.tor.router.enable [ 9053 ];

    # Enable squid with shutdown_lifetime set to 0, as it instead would delay service stopping.
    services.squid = lib.mkIf config.networking.tor.client.enable {
      enable = config.networking.tor.client.clearnetProxy.enable;
      proxyAddress = "127.0.0.1";
      proxyPort = config.networking.tor.client.clearnetProxy.port;
      extraConfig = ''
        shutdown_lifetime 0 seconds;
      '';
    };

    # Sometimes squid would refuse to start if no network is available.
    systemd.services.squid.after = lib.mkIf config.networking.tor.client.enable [
      "network-online.target"
    ];

    systemd.services.squid.wants = lib.mkIf config.networking.tor.client.enable [
      "network-online.target"
    ];

    networking.nftables.enable = lib.mkIf (
      config.networking.tor.client.enable || config.networking.tor.router.enable
    ) true;

    # Patch rules before checking them as they would simply fail as both "tor"
    # and "squid" users aren't available during build.
    networking.nftables.preCheckRuleset = ''
      sed -i 's/skuid tor/skuid 1/' ruleset.conf
      sed -i 's/skuid squid/skuid 2/' ruleset.conf
    '';

    # Here are the nftables for the routing operations. As you may notice the
    # family is "inet" so it handles both IPv4 and IPv6, but there are no rules
    # regarding IPv6 traffic, so it gets simply dropped at the end of filter
    # chains. That's on purpose as IPv6 has not been tested.
    networking.nftables.tables = {
      tor = {
        enable = config.networking.tor.client.enable;
        family = "inet";
        content = ''

          ${buildSubnetsSet "reserved_subnets" reservedSubnets}

          ${buildSubnetsSet "allowed_destinations" config.networking.tor.client.allowedDestinations}

          ${buildSet "ifname" null "allowed_ifs" config.networking.tor.client.allowedInterfaces}

          ${buildSet "mark" null "allowed_marks" config.networking.tor.client.allowedFwMarks}

          chain tor_nat_output {
            type nat hook output priority ${toString config.networking.tor.natPriority}

            oifname lo return
            ip daddr 127.0.0.0/8 return
            ip6 daddr ::1/128 return

            oifname @allowed_ifs return # Do not modify any packet destined to allowed intfs
            meta mark @allowed_marks return # Do not modify any packet marked with allowed marks

            skuid tor return # Do not modify any tor packets

            # Do not modify any squid packets
            ${lib.optionalString (config.networking.tor.client.clearnetProxy.enable)

              "skuid squid return"
            }

            # Here we prioritize allowedDestinations over DNS redirection,
            # but we redirect DNS requests before allowing local addresses, as
            # most network configurations have local IP addresses as DNS servers.
            ip daddr @allowed_destinations return
            ip protocol udp udp dport 53 dnat to 127.0.0.1:9053 # route dns before allowing local addresses
            ip daddr @reserved_subnets ip daddr != ${config.networking.tor.VirtualAddrNetworkIPv4} return

            ip protocol tcp dnat to 127.0.0.1:9040 # this rewrites the dest addr but not the interface!
          }

          chain tor_filter_output {
            # Set filterPriority and drop everything by default.
            type filter hook output priority ${toString config.networking.tor.filterPriority}; policy drop;

            ct state established,related accept

            oifname lo accept # For processes that connect to interface IPs, like 192.186.1.150 and are routed through lo
            ip daddr 127.0.0.0/8 accept # DNATed packets have ethernet intf but local addresses

            oifname @allowed_ifs accept
            meta mark @allowed_marks accept

            skuid tor accept

            ${lib.optionalString (config.networking.tor.client.clearnetProxy.enable)

              "skuid squid accept"
            }

            ip daddr @reserved_subnets accept
            ip daddr @allowed_destinations accept
          }
        '';
      };

      tor-router = {
        enable = config.networking.tor.router.enable;
        family = "inet";
        content = ''

          ${buildSubnetsSet "reserved_subnets" reservedSubnets}
          ${buildSubnetsSet "allowed_destinations" config.networking.tor.router.allowedDestinations}

          ${buildSubnetsSet "allowed_sources" config.networking.tor.router.allowedSources}

          chain tor_nat_prerouting {
            type nat hook prerouting priority ${toString config.networking.tor.natPriority}

            ip daddr @reserved_subnets ip daddr != ${config.networking.tor.VirtualAddrNetworkIPv4} return
            ip saddr @allowed_sources return
            ip daddr @allowed_destinations return

            ip protocol udp udp dport 53 redirect to :9053
            ip protocol tcp tcp flags syn redirect to :9040
          }

          chain tor_filter_forward {
            type filter hook forward priority ${toString config.networking.tor.filterPriority}; policy drop

            ct state established,related accept

            ip daddr @reserved_subnets accept
            ip saddr @allowed_sources accept
            ip daddr @allowed_destinations accept
          }
        '';
      };

    };

    boot.kernel.sysctl."net.ipv4.ip_forward" = lib.mkIf config.networking.tor.router.enable (
      lib.mkDefault 1
    );

  };

}
