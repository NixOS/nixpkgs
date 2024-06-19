# This module enables Network Address Translation (NAT).
# XXX: todo: support multiple upstream links
# see http://yesican.chsoft.biz/lartc/MultihomedLinuxNetworking.html

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking.nat;

in

{

  options = {

    networking.nat.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable Network Address Translation (NAT).
      '';
    };

    networking.nat.enableIPv6 = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable IPv6 NAT.
      '';
    };

    networking.nat.internalInterfaces = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "eth0" ];
      description = ''
        The interfaces for which to perform NAT. Packets coming from
        these interface and destined for the external interface will
        be rewritten.
      '';
    };

    networking.nat.internalIPs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "192.168.1.0/24" ];
      description = ''
        The IP address ranges for which to perform NAT.  Packets
        coming from these addresses (on any interface) and destined
        for the external interface will be rewritten.
      '';
    };

    networking.nat.internalIPv6s = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "fc00::/64" ];
      description = ''
        The IPv6 address ranges for which to perform NAT.  Packets
        coming from these addresses (on any interface) and destined
        for the external interface will be rewritten.
      '';
    };

    networking.nat.externalInterface = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "eth1";
      description = ''
        The name of the external network interface.
      '';
    };

    networking.nat.externalIP = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "203.0.113.123";
      description = ''
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
      description = ''
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
            default = [ ];
            example = literalExpression ''[ "55.1.2.3" ]'';
            description = "Public IPs for NAT reflection; for connections to `loopbackip:sourcePort` from the host itself and from other hosts behind NAT";
          };
        };
      });
      default = [ ];
      example = [
        { sourcePort = 8080; destination = "10.0.0.1:80"; proto = "tcp"; }
        { sourcePort = 8080; destination = "[fc00::2]:80"; proto = "tcp"; }
      ];
      description = ''
        List of forwarded ports from the external interface to
        internal destinations by using DNAT. Destination can be
        IPv6 if IPv6 NAT is enabled.
      '';
    };

    networking.nat.dmzHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "10.0.0.1";
      description = ''
        The local IP address to which all traffic that does not match any
        forwarding rule is forwarded.
      '';
    };

  };


  config = mkIf config.networking.nat.enable {

    assertions = [
      {
        assertion = cfg.enableIPv6 -> config.networking.enableIPv6;
        message = "networking.nat.enableIPv6 requires networking.enableIPv6";
      }
      {
        assertion = (cfg.dmzHost != null) -> (cfg.externalInterface != null);
        message = "networking.nat.dmzHost requires networking.nat.externalInterface";
      }
      {
        assertion = (cfg.forwardPorts != [ ]) -> (cfg.externalInterface != null);
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

  };
}
