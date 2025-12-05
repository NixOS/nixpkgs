{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.networking.firewall;

  incomingTrustedInterfaces = lib.concatStringsSep ", " (map (x: ''"${x}"'') cfg.trustedInterfaces);
  outgoingTrustedInterfaces = lib.concatStringsSep ", " (
    map (x: ''"${x}"'') cfg.filterOutput.trustedInterfaces
  );

  portsToNftSet =
    ports: portRanges:
    lib.concatStringsSep ", " (
      map (x: toString x) ports ++ map (x: "${toString x.from}-${toString x.to}") portRanges
    );

in

{
  options = {
    networking.firewall = {
      extraInputRules = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = "ip6 saddr { fc00::/7, fe80::/10 } tcp dport 24800 accept";
        description = ''
          Additional nftables rules to be appended to the input-allow
          chain.

          This option only works with the nftables based firewall.
        '';
      };

      extraForwardRules = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = "iifname wg0 accept";
        description = ''
          Additional nftables rules to be appended to the forward-allow
          chain.

          This option only works with the nftables based firewall.
        '';
      };

      extraReversePathFilterRules = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = "fib daddr . mark . iif type local accept";
        description = ''
          Additional nftables rules to be appended to the rpfilter-allow
          chain.

          This option only works with the nftables based firewall.
        '';
      };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.backend == "nftables") {
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
        assertion = cfg.pingLimit == null || !(lib.hasPrefix "--" cfg.pingLimit);
        message = "nftables syntax like \"2/second\" should be used in networking.firewall.pingLimit";
      }
      {
        assertion = config.networking.nftables.rulesetFile == null;
        message = "networking.nftables.rulesetFile conflicts with the firewall";
      }
    ];

    environment.systemPackages = [ pkgs.nixos-firewall-tool ];

    networking.nftables.tables."nixos-fw".family = "inet";
    networking.nftables.tables."nixos-fw".content = ''
      set temp-ports {
        comment "Temporarily opened ports"
        type inet_proto . inet_service
        flags interval
        auto-merge
      }

      ${lib.optionalString (cfg.checkReversePath != false) ''
        chain rpfilter {
          type filter hook prerouting priority mangle + 10; policy drop;

          meta nfproto ipv4 udp sport . udp dport { 67 . 68, 68 . 67 } accept comment "DHCPv4 client/server"
          fib saddr . mark ${lib.optionalString (cfg.checkReversePath != "loose") ". iif"} oif exists accept

          jump rpfilter-allow

          ${lib.optionalString cfg.logReversePathDrops ''
            log level info prefix "rpfilter drop: "
          ''}

        }
      ''}

      chain rpfilter-allow {
        ${cfg.extraReversePathFilterRules}
      }

      chain input {
        type filter hook input priority filter; policy drop;

        ${lib.optionalString (
          incomingTrustedInterfaces != ""
        ) ''iifname { ${incomingTrustedInterfaces} } accept comment "trusted interfaces"''}

        # Some ICMPv6 types like NDP is untracked
        ct state vmap {
          invalid : drop,
          established : accept,
          related : accept,
          new : jump input-allow,
          untracked: jump input-allow,
        }

        ${lib.optionalString cfg.logRefusedConnections ''
          tcp flags syn / fin,syn,rst,ack log level info prefix "refused connection: "
        ''}
        ${lib.optionalString (cfg.logRefusedPackets && !cfg.logRefusedUnicastsOnly) ''
          pkttype broadcast log level info prefix "refused broadcast: "
          pkttype multicast log level info prefix "refused multicast: "
        ''}
        ${lib.optionalString cfg.logRefusedPackets ''
          pkttype host log level info prefix "refused packet: "
        ''}

        ${lib.optionalString cfg.rejectPackets ''
          meta l4proto tcp reject with tcp reset
          reject
        ''}

      }

      chain input-allow {

        ${lib.concatStrings (
          lib.mapAttrsToList (
            iface: cfg:
            let
              ifaceExpr = lib.optionalString (iface != "default") "iifname ${iface}";
              tcpSet = portsToNftSet cfg.allowedTCPPorts cfg.allowedTCPPortRanges;
              udpSet = portsToNftSet cfg.allowedUDPPorts cfg.allowedUDPPortRanges;
            in
            ''
              ${lib.optionalString (tcpSet != "") "${ifaceExpr} tcp dport { ${tcpSet} } accept"}
              ${lib.optionalString (udpSet != "") "${ifaceExpr} udp dport { ${udpSet} } accept"}
            ''
          ) cfg.allInterfaces
        )}

        meta l4proto . th dport @temp-ports accept

        ${lib.optionalString cfg.allowPing ''
          icmp type echo-request ${
            lib.optionalString (cfg.pingLimit != null) "limit rate ${cfg.pingLimit}"
          } accept comment "allow ping"
        ''}

        icmpv6 type != { nd-redirect, 139 } accept comment "Accept all ICMPv6 messages except redirects and node information queries (type 139).  See RFC 4890, section 4.4."
        ip6 daddr fe80::/64 udp dport 546 accept comment "DHCPv6 client"

        ${cfg.extraInputRules}

      }

      ${lib.optionalString cfg.filterOutput.enabled ''
        chain output {
          type filter hook output priority filter; policy drop;

          ${lib.optionalString (
            outgoingTrustedInterfaces != ""
          ) ''oifname { ${outgoingTrustedInterfaces} } accept comment "trusted interfaces"''}

          ip6 nexthdr icmpv6 accept comment "Accept all ICMPv6 messages."

          ct state vmap {
            invalid : drop,
            established : accept,
            related : accept,
            new : jump output-allow,
          }

          ${lib.optionalString cfg.logRefusedConnections ''
            tcp flags syn / fin,syn,rst,ack log level info prefix "refused outgoing connection: "
          ''}
          ${lib.optionalString (cfg.logRefusedPackets && !cfg.logRefusedUnicastsOnly) ''
            pkttype broadcast log level info prefix "refused outgoing broadcast: "
            pkttype multicast log level info prefix "refused outgoing multicast: "
          ''}
          ${lib.optionalString cfg.logRefusedPackets ''
            pkttype host log level info prefix "refused outgoing packet: "
          ''}
        }

        chain output-allow {
          ${lib.concatStrings (
            lib.mapAttrsToList (
              iface: cfg:
              let
                ifaceExpr = lib.optionalString (iface != "default") "oifname ${iface}";
                tcpSet = portsToNftSet cfg.allowedTCPPorts cfg.allowedTCPPortRanges;
                udpSet = portsToNftSet cfg.allowedUDPPorts cfg.allowedUDPPortRanges;
              in
              ''
                ${lib.optionalString (tcpSet != "") "${ifaceExpr} tcp dport { ${tcpSet} } accept"}
                ${lib.optionalString (udpSet != "") "${ifaceExpr} udp dport { ${udpSet} } accept"}
              ''
            ) cfg.filterOutput.allInterfaces
          )}

          ${lib.optionalString cfg.allowPing ''
            icmp type { echo-request, echo-reply } ${
              lib.optionalString (cfg.pingLimit != null) "limit rate ${cfg.pingLimit}"
            } accept comment "allow ping"
          ''}

          ip6 daddr fe80::/64 udp dport 547 accept comment "DHCPv6 client"

          ${cfg.filterOutput.extraRules}
        }
      ''}

      ${lib.optionalString cfg.filterForward ''
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
