# This module enables Network Address Translation (NAT).
# XXX: todo: support multiple upstream links
# see http://yesican.chsoft.biz/lartc/MultihomedLinuxNetworking.html

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking.nat;

  dest = if cfg.externalIP == null then "-j MASQUERADE" else "-j SNAT --to-source ${cfg.externalIP}";

  flushNat = ''
    iptables -w -t nat -D PREROUTING -j nixos-nat-pre 2>/dev/null|| true
    iptables -w -t nat -F nixos-nat-pre 2>/dev/null || true
    iptables -w -t nat -X nixos-nat-pre 2>/dev/null || true
    iptables -w -t nat -D POSTROUTING -j nixos-nat-post 2>/dev/null || true
    iptables -w -t nat -F nixos-nat-post 2>/dev/null || true
    iptables -w -t nat -X nixos-nat-post 2>/dev/null || true
  '';

  setupNat = ''
    # Create subchain where we store rules
    iptables -w -t nat -N nixos-nat-pre
    iptables -w -t nat -N nixos-nat-post

    # We can't match on incoming interface in POSTROUTING, so
    # mark packets coming from the external interfaces.
    ${concatMapStrings (iface: ''
      iptables -w -t nat -A nixos-nat-pre \
        -i '${iface}' -j MARK --set-mark 1
    '') cfg.internalInterfaces}

    # NAT the marked packets.
    ${optionalString (cfg.internalInterfaces != []) ''
      iptables -w -t nat -A nixos-nat-post -m mark --mark 1 \
        -o ${cfg.externalInterface} ${dest}
    ''}

    # NAT packets coming from the internal IPs.
    ${concatMapStrings (range: ''
      iptables -w -t nat -A nixos-nat-post \
        -s '${range}' -o ${cfg.externalInterface} ${dest}
    '') cfg.internalIPs}

    # NAT from external ports to internal ports.
    ${concatMapStrings (fwd: ''
      iptables -w -t nat -A nixos-nat-pre \
        -i ${cfg.externalInterface} -p ${fwd.proto} \
        --dport ${builtins.toString fwd.sourcePort} \
        -j DNAT --to-destination ${fwd.destination}
    '') cfg.forwardPorts}

    ${optionalString (cfg.dmzHost != null) ''
      iptables -w -t nat -A nixos-nat-pre \
        -i ${cfg.externalInterface} -j DNAT \
	--to-destination ${cfg.dmzHost}
    ''}

    # Append our chains to the nat tables
    iptables -w -t nat -A PREROUTING -j nixos-nat-pre
    iptables -w -t nat -A POSTROUTING -j nixos-nat-post
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

    networking.nat.externalInterface = mkOption {
      type = types.str;
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
            description = "Forward connection to destination ip:port; to specify a port range, use ip:start-end";
          };

          proto = mkOption {
            type = types.str;
            default = "tcp";
            example = "udp";
            description = "Protocol of forwarded connection";
          };
        };
      });
      default = [];
      example = [ { sourcePort = 8080; destination = "10.0.0.1:80"; proto = "tcp"; } ];
      description =
        ''
          List of forwarded ports from the external interface to
          internal destinations by using DNAT.
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

  };


  ###### implementation

  config = mkMerge [
    { networking.firewall.extraCommands = mkBefore flushNat; }
    (mkIf config.networking.nat.enable {

      environment.systemPackages = [ pkgs.iptables ];

      boot = {
        kernelModules = [ "nf_nat_ftp" ];
        kernel.sysctl = {
          "net.ipv4.conf.all.forwarding" = mkOverride 99 true;
          "net.ipv4.conf.default.forwarding" = mkOverride 99 true;
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
        path = [ pkgs.iptables ];
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
