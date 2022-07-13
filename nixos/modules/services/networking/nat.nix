# This module enables Network Address Translation (NAT).
# XXX: todo: support multiple upstream links
# see http://yesican.chsoft.biz/lartc/MultihomedLinuxNetworking.html

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.nat;

  mkDest = externalIP: if externalIP == null
                       then "-j MASQUERADE"
                       else "-j SNAT --to-source ${externalIP}";
  dest = mkDest cfg.externalIP;
  destIPv6 = mkDest cfg.externalIPv6;

  # Whether given IP (plus optional port) is an IPv6.
  isIPv6 = ip: builtins.length (lib.splitString ":" ip) > 2;

  helpers = import ./helpers.nix { inherit config lib; };

  flushNat = ''
    ${helpers}
    ip46tables -w -t nat -D PREROUTING -j nixos-nat-pre 2>/dev/null|| true
    ip46tables -w -t nat -F nixos-nat-pre 2>/dev/null || true
    ip46tables -w -t nat -X nixos-nat-pre 2>/dev/null || true
    ip46tables -w -t nat -D POSTROUTING -j nixos-nat-post 2>/dev/null || true
    ip46tables -w -t nat -F nixos-nat-post 2>/dev/null || true
    ip46tables -w -t nat -X nixos-nat-post 2>/dev/null || true
    ip46tables -w -t nat -D OUTPUT -j nixos-nat-out 2>/dev/null || true
    ip46tables -w -t nat -F nixos-nat-out 2>/dev/null || true
    ip46tables -w -t nat -X nixos-nat-out 2>/dev/null || true

    ${cfg.extraStopCommands}
  '';

  mkSetupNat = { iptables, dest, internalIPs, forwardPorts }: ''
    # We can't match on incoming interface in POSTROUTING, so
    # mark packets coming from the internal interfaces.
    ${concatMapStrings (iface: ''
      ${iptables} -w -t nat -A nixos-nat-pre \
        -i '${iface}' -j MARK --set-mark 1
    '') cfg.internalInterfaces}

    # NAT the marked packets.
    ${optionalString (cfg.internalInterfaces != []) ''
      ${iptables} -w -t nat -A nixos-nat-post -m mark --mark 1 \
        ${optionalString (cfg.externalInterface != null) "-o ${cfg.externalInterface}"} ${dest}
    ''}

    # NAT packets coming from the internal IPs.
    ${concatMapStrings (range: ''
      ${iptables} -w -t nat -A nixos-nat-post \
        -s '${range}' ${optionalString (cfg.externalInterface != null) "-o ${cfg.externalInterface}"} ${dest}
    '') internalIPs}

    # NAT from external ports to internal ports.
    ${concatMapStrings (fwd: ''
      ${iptables} -w -t nat -A nixos-nat-pre \
        -i ${toString cfg.externalInterface} -p ${fwd.proto} \
        --dport ${builtins.toString fwd.sourcePort} \
        -j DNAT --to-destination ${fwd.destination}

      ${concatMapStrings (loopbackip:
        let
          matchIP          = if isIPv6 fwd.destination then "[[]([0-9a-fA-F:]+)[]]" else "([0-9.]+)";
          m                = builtins.match "${matchIP}:([0-9-]+)" fwd.destination;
          destinationIP    = if m == null then throw "bad ip:ports `${fwd.destination}'" else elemAt m 0;
          destinationPorts = if m == null then throw "bad ip:ports `${fwd.destination}'" else builtins.replaceStrings ["-"] [":"] (elemAt m 1);
        in ''
          # Allow connections to ${loopbackip}:${toString fwd.sourcePort} from the host itself
          ${iptables} -w -t nat -A nixos-nat-out \
            -d ${loopbackip} -p ${fwd.proto} \
            --dport ${builtins.toString fwd.sourcePort} \
            -j DNAT --to-destination ${fwd.destination}

          # Allow connections to ${loopbackip}:${toString fwd.sourcePort} from other hosts behind NAT
          ${iptables} -w -t nat -A nixos-nat-pre \
            -d ${loopbackip} -p ${fwd.proto} \
            --dport ${builtins.toString fwd.sourcePort} \
            -j DNAT --to-destination ${fwd.destination}

          ${iptables} -w -t nat -A nixos-nat-post \
            -d ${destinationIP} -p ${fwd.proto} \
            --dport ${destinationPorts} \
            -j SNAT --to-source ${loopbackip}
        '') fwd.loopbackIPs}
    '') forwardPorts}
  '';

  setupNat = ''
    ${helpers}
    # Create subchains where we store rules
    ip46tables -w -t nat -N nixos-nat-pre
    ip46tables -w -t nat -N nixos-nat-post
    ip46tables -w -t nat -N nixos-nat-out

    ${mkSetupNat {
      iptables = "iptables";
      inherit dest;
      inherit (cfg) internalIPs;
      forwardPorts = filter (x: !(isIPv6 x.destination)) cfg.forwardPorts;
    }}

    ${optionalString cfg.enableIPv6 (mkSetupNat {
      iptables = "ip6tables";
      dest = destIPv6;
      internalIPs = cfg.internalIPv6s;
      forwardPorts = filter (x: isIPv6 x.destination) cfg.forwardPorts;
    })}

    ${optionalString (cfg.dmzHost != null) ''
      iptables -w -t nat -A nixos-nat-pre \
        -i ${toString cfg.externalInterface} -j DNAT \
        --to-destination ${cfg.dmzHost}
    ''}

    ${cfg.extraCommands}

    # Append our chains to the nat tables
    ip46tables -w -t nat -A PREROUTING -j nixos-nat-pre
    ip46tables -w -t nat -A POSTROUTING -j nixos-nat-post
    ip46tables -w -t nat -A OUTPUT -j nixos-nat-out
  '';

in

{

  ###### interface

  options = {

    networking.nat.enable = mkOption {
      type = types.bool;
      default = false;
      description =
        ''
          Whether to enable Network Address Translation (NAT).
        '';
    };

    networking.nat.enableIPv6 = mkOption {
      type = types.bool;
      default = false;
      description =
        ''
          Whether to enable IPv6 NAT.
        '';
    };

    networking.nat.internalInterfaces = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "eth0" ];
      description =
        ''
          The interfaces for which to perform NAT. Packets coming from
          these interface and destined for the external interface will
          be rewritten.
        '';
    };

    networking.nat.internalIPs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "192.168.1.0/24" ];
      description =
        ''
          The IP address ranges for which to perform NAT.  Packets
          coming from these addresses (on any interface) and destined
          for the external interface will be rewritten.
        '';
    };

    networking.nat.internalIPv6s = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "fc00::/64" ];
      description =
        ''
          The IPv6 address ranges for which to perform NAT.  Packets
          coming from these addresses (on any interface) and destined
          for the external interface will be rewritten.
        '';
    };

    networking.nat.externalInterface = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "eth1";
      description =
        ''
          The name of the external network interface.
        '';
    };

    networking.nat.externalIP = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "203.0.113.123";
      description =
        ''
          The public IP address to which packets from the local
          network are to be rewritten.  If this is left empty, the
          IP address associated with the external interface will be
          used.
        '';
    };

    networking.nat.externalIPv6 = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "2001:dc0:2001:11::175";
      description =
        ''
          The public IPv6 address to which packets from the local
          network are to be rewritten.  If this is left empty, the
          IP address associated with the external interface will be
          used.
        '';
    };

    networking.nat.forwardPorts = mkOption {
      type = with types; listOf (submodule {
        options = {
          sourcePort = mkOption {
            type = types.either types.int (types.strMatching "[[:digit:]]+:[[:digit:]]+");
            example = 8080;
            description = "Source port of the external interface; to specify a port range, use a string with a colon (e.g. \"60000:61000\")";
          };

          destination = mkOption {
            type = types.str;
            example = "10.0.0.1:80";
            description = "Forward connection to destination ip:port (or [ipv6]:port); to specify a port range, use ip:start-end";
          };

          proto = mkOption {
            type = types.str;
            default = "tcp";
            example = "udp";
            description = "Protocol of forwarded connection";
          };

          loopbackIPs = mkOption {
            type = types.listOf types.str;
            default = [];
            example = literalExpression ''[ "55.1.2.3" ]'';
            description = "Public IPs for NAT reflection; for connections to `loopbackip:sourcePort' from the host itself and from other hosts behind NAT";
          };
        };
      });
      default = [];
      example = [
        { sourcePort = 8080; destination = "10.0.0.1:80"; proto = "tcp"; }
        { sourcePort = 8080; destination = "[fc00::2]:80"; proto = "tcp"; }
      ];
      description =
        ''
          List of forwarded ports from the external interface to
          internal destinations by using DNAT. Destination can be
          IPv6 if IPv6 NAT is enabled.
        '';
    };

    networking.nat.dmzHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "10.0.0.1";
      description =
        ''
          The local IP address to which all traffic that does not match any
          forwarding rule is forwarded.
        '';
    };

    networking.nat.extraCommands = mkOption {
      type = types.lines;
      default = "";
      example = "iptables -A INPUT -p icmp -j ACCEPT";
      description =
        ''
          Additional shell commands executed as part of the nat
          initialisation script.
        '';
    };

    networking.nat.extraStopCommands = mkOption {
      type = types.lines;
      default = "";
      example = "iptables -D INPUT -p icmp -j ACCEPT || true";
      description =
        ''
          Additional shell commands executed as part of the nat
          teardown script.
        '';
    };

  };


  ###### implementation

  config = mkMerge [
    { networking.firewall.extraCommands = mkBefore flushNat; }
    (mkIf config.networking.nat.enable {

      assertions = [
        { assertion = cfg.enableIPv6           -> config.networking.enableIPv6;
          message = "networking.nat.enableIPv6 requires networking.enableIPv6";
        }
        { assertion = (cfg.dmzHost != null)    -> (cfg.externalInterface != null);
          message = "networking.nat.dmzHost requires networking.nat.externalInterface";
        }
        { assertion = (cfg.forwardPorts != []) -> (cfg.externalInterface != null);
          message = "networking.nat.forwardPorts requires networking.nat.externalInterface";
        }
      ];

      # Use the same iptables package as in config.networking.firewall.
      # When the firewall is enabled, this should be deduplicated without any
      # error.
      environment.systemPackages = [ config.networking.firewall.package ];

      boot = {
        kernelModules = [ "nf_nat_ftp" ];
        kernel.sysctl = {
          "net.ipv4.conf.all.forwarding" = mkOverride 99 true;
          "net.ipv4.conf.default.forwarding" = mkOverride 99 true;
        } // optionalAttrs cfg.enableIPv6 {
          # Do not prevent IPv6 autoconfiguration.
          # See <http://strugglers.net/~andy/blog/2011/09/04/linux-ipv6-router-advertisements-and-forwarding/>.
          "net.ipv6.conf.all.accept_ra" = mkOverride 99 2;
          "net.ipv6.conf.default.accept_ra" = mkOverride 99 2;

          # Forward IPv6 packets.
          "net.ipv6.conf.all.forwarding" = mkOverride 99 true;
          "net.ipv6.conf.default.forwarding" = mkOverride 99 true;
        };
      };

      networking.firewall = mkIf config.networking.firewall.enable {
        extraCommands = setupNat;
        extraStopCommands = flushNat;
      };

      systemd.services = mkIf (!config.networking.firewall.enable) { nat = {
        description = "Network Address Translation";
        wantedBy = [ "network.target" ];
        after = [ "network-pre.target" "systemd-modules-load.service" ];
        path = [ config.networking.firewall.package ];
        unitConfig.ConditionCapability = "CAP_NET_ADMIN";

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        script = flushNat + setupNat;

        postStop = flushNat;
      }; };
    })
  ];
}
