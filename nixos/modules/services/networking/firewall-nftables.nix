{ config, lib, ... }:

let

  inherit (lib) mkIf mkOption types mdDoc optionalString concatStringsSep hasPrefix mapAttrsToList;

  cfg = config.networking.firewall;

  ifaceSet = concatStringsSep ", " (
    map (x: ''"${x}"'') cfg.trustedInterfaces
  );

  writeElements = elements: optionalString (elements != "") "elements = { ${elements} }";

  portsToNftSet = ports: portRanges: concatStringsSep ", " (
    map (x: toString x) ports
    ++ map (x: "${toString x.from}-${toString x.to}") portRanges
  );

  interfacePorts = builtins.concatStringsSep ", " (builtins.concatLists (mapAttrsToList
  (interface: value:
    map (port: "${interface} . tcp . ${toString port}") value.allowedTCPPorts
    ++ map (range: "${interface} . tcp . ${toString range.from}-${toString range.to}") value.allowedTCPPortRanges
    ++ map (port: "${interface} . udp . ${toString port}") value.allowedUDPPorts
    ++ map (range: "${interface} . udp . ${toString range.from}-${toString range.to}") value.allowedUDPPortRanges
  ) cfg.interfaces));

in

{

  options = {

    networking.firewall = {
      extraInputRules = mkOption {
        type = types.lines;
        default = "";
        example = "ip6 saddr { fc00::/7, fe80::/10 } tcp dport 24800 accept";
        description = mdDoc ''
          Additional nftables rules to be appended to the input-allow
          chain.

          This option only works with the nftables based firewall.
        '';
      };

      extraForwardRules = mkOption {
        type = types.lines;
        default = "";
        example = "iifname wg0 accept";
        description = mdDoc ''
          Additional nftables rules to be appended to the forward-allow
          chain.

          This option only works with the nftables based firewall.
        '';
      };
    };

  };

  config = mkIf (cfg.enable && config.networking.nftables.enable) {

    assertions = [
      {
        assertion = cfg.extraCommands == "";
        message = "extraCommands is incompatible with the nftables based firewall: ${cfg.extraCommands}";
      }
      {
        assertion = cfg.extraStopCommands == "";
        message = "extraStopCommands is incompatible with the nftables based firewall: ${cfg.extraStopCommands}";
      }
      {
        assertion = cfg.pingLimit == null || !(hasPrefix "--" cfg.pingLimit);
        message = "nftables syntax like \"2/second\" should be used in networking.firewall.pingLimit";
      }
      {
        assertion = config.networking.nftables.rulesetFile == null;
        message = "networking.nftables.rulesetFile conflicts with the firewall";
      }
    ];

    networking.nftables.tables."nixos-fw".family = "inet";
    networking.nftables.tables."nixos-fw".content = ''
        set tcp-ports {
          comment "Open TCP ports"
          type inet_service
          flags interval
          auto-merge
          ${writeElements (portsToNftSet cfg.allowedTCPPorts cfg.allowedTCPPortRanges)}
        }

        set udp-ports {
          comment "Open UDP ports"
          type inet_service
          flags interval
          auto-merge
          ${writeElements (portsToNftSet cfg.allowedUDPPorts cfg.allowedUDPPortRanges)}
        }

        set interface-ports {
          comment "Interface-specific open ports"
          type ifname . inet_proto . inet_service
          flags interval
          auto-merge
          ${writeElements interfacePorts}
        }

        ${optionalString (cfg.checkReversePath != false) ''
          chain rpfilter {
            type filter hook prerouting priority mangle + 10; policy drop;

            meta nfproto ipv4 udp sport . udp dport { 67 . 68, 68 . 67 } accept comment "DHCPv4 client/server"
            fib saddr . mark ${optionalString (cfg.checkReversePath != "loose") ". iif"} oif exists accept

            ${optionalString cfg.logReversePathDrops ''
              log level info prefix "rpfilter drop: "
            ''}

          }
        ''}

        chain input {
          type filter hook input priority filter; policy drop;

          ${optionalString (ifaceSet != "") ''iifname { ${ifaceSet} } accept comment "trusted interfaces"''}

          # Some ICMPv6 types like NDP is untracked
          ct state vmap {
            invalid : drop,
            established : accept,
            related : accept,
            new : jump input-allow,
            untracked: jump input-allow,
          }

          ${optionalString cfg.logRefusedConnections ''
            tcp flags syn / fin,syn,rst,ack log level info prefix "refused connection: "
          ''}
          ${optionalString (cfg.logRefusedPackets && !cfg.logRefusedUnicastsOnly) ''
            pkttype broadcast log level info prefix "refused broadcast: "
            pkttype multicast log level info prefix "refused multicast: "
          ''}
          ${optionalString cfg.logRefusedPackets ''
            pkttype host log level info prefix "refused packet: "
          ''}

          ${optionalString cfg.rejectPackets ''
            meta l4proto tcp reject with tcp reset
            reject
          ''}

        }

        chain input-allow {

          tcp dport @tcp-ports accept
          udp dport @udp-ports accept
          iifname . meta l4proto . th dport @interface-ports accept

          ${optionalString cfg.allowPing ''
            icmp type echo-request ${optionalString (cfg.pingLimit != null) "limit rate ${cfg.pingLimit}"} accept comment "allow ping"
          ''}

          icmpv6 type != { nd-redirect, 139 } accept comment "Accept all ICMPv6 messages except redirects and node information queries (type 139).  See RFC 4890, section 4.4."
          ip6 daddr fe80::/64 udp dport 546 accept comment "DHCPv6 client"

          ${cfg.extraInputRules}

        }

        ${optionalString cfg.filterForward ''
          chain forward {
            type filter hook forward priority filter; policy drop;

            ct state vmap {
              invalid : drop,
              established : accept,
              related : accept,
              new : jump forward-allow,
              untracked : jump forward-allow,
            }

          }

          chain forward-allow {

            icmpv6 type != { router-renumbering, 139 } accept comment "Accept all ICMPv6 messages except renumbering and node information queries (type 139).  See RFC 4890, section 4.3."

            ct status dnat accept comment "allow port forward"

            ${cfg.extraForwardRules}

          }
        ''}
    '';

  };

}
