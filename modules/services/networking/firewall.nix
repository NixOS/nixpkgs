# This module enables a simple firewall.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.networking.firewall;

in

{

  ###### interface

  options = {
  
    networking.firewall.enable = mkOption {
      default = false;
      description =
        ''
          Whether to enable the firewall.  This is a simple stateful
          firewall that blocks connection attempts to unauthorised TCP
          or UDP ports on this machine.  It does not affect packet
          forwarding.
        '';
    };
  
    networking.firewall.logRefusedConnections = mkOption {
      default = true;
      description =
        ''
          Whether to log rejected or dropped incoming connections.
        '';
    };
  
    networking.firewall.logRefusedPackets = mkOption {
      default = false;
      description =
        ''
          Whether to log all rejected or dropped incoming packets.
          This tends to give a lot of log messages, so it's mostly
          useful for debugging.
        '';
    };

    networking.firewall.rejectPackets = mkOption {
      default = false;
      description =
        ''
          If set, forbidden packets are rejected rather than dropped
          (ignored).  This means that a ICMP "port unreachable" error
          message is sent back to the client.  Rejecting packets makes
          port scanning somewhat easier.
        '';
    };
  
    networking.firewall.allowedTCPPorts = mkOption {
      default = [];
      example = [ 22 80 ];
      type = types.list types.int;
      description =
        ''
          List of TCP ports on which incoming connections are
          accepted.
        '';
    };
  
    networking.firewall.allowedUDPPorts = mkOption {
      default = [];
      example = [ 53 ];
      type = types.list types.int;
      description =
        ''
          List of open UDP ports.
        '';
    };
  
    networking.firewall.allowPing = mkOption {
      default = false;
      type = types.bool;
      description =
        ''
          Whether to respond to incoming ICMPv4 echo requests
          ("pings").  ICMPv6 pings are always allowed because the
          larger address space of IPv6 makes network scanning much
          less effective.
        '';
    };
  
  };


  ###### implementation

  # !!! Maybe if `enable' is false, the firewall should still be built
  # but not started by default.  However, currently nixos-rebuild
  # doesn't deal with such Upstart jobs properly (it starts them if
  # they are changed, regardless of whether the start condition
  # holds).
  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.iptables ];

    jobs.firewall =
      { startOn = "started network-interfaces";

        path = [ pkgs.iptables ];

        preStart =
          ''
            # Helper command to manipulate both the IPv4 and IPv6 tables.
            ip46tables() {
              iptables "$@"
              ip6tables "$@"
            }

            ip46tables -F INPUT
            ip46tables -F FW_REFUSE || true
            ip46tables -X # flush unused chains
            ip46tables -P INPUT DROP


            # The "FW_REFUSE" chain performs logging and
            # rejecting/dropping of packets.
            ip46tables -N FW_REFUSE

            ${optionalString cfg.logRefusedConnections ''
              ip46tables -A FW_REFUSE -p tcp --syn -j LOG --log-level info --log-prefix "rejected connection: "
            ''}
            ${optionalString cfg.logRefusedPackets ''
              ip46tables -A FW_REFUSE -j LOG --log-level info --log-prefix "rejected packet: "
            ''}

            ip46tables -A FW_REFUSE -j ${if cfg.rejectPackets then "REJECT" else "DROP"}


            # Accept all traffic on the loopback interface.
            ip46tables -A INPUT -i lo -j ACCEPT

            # Accept packets from established or related connections.
            ip46tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

            # Accept connections to the allowed TCP ports.
            ${concatMapStrings (port:
                ''
                  ip46tables -A INPUT -p tcp --dport ${toString port} -j ACCEPT
                ''
              ) cfg.allowedTCPPorts
            }

            # Accept packets on the allowed UDP ports.
            ${concatMapStrings (port:
                ''
                  ip46tables -A INPUT -p udp --dport ${toString port} -j ACCEPT
                ''
              ) cfg.allowedUDPPorts
            }

            # Accept IPv4 multicast.  Not a big security risk since
            # probably nobody is listening anyway.
            iptables -A INPUT -d 224.0.0.0/4 -j ACCEPT

            # Optionally respond to ICMPv4 pings.
            ${optionalString cfg.allowPing ''
              iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
            ''}

            # Accept all ICMPv6 messages except redirects and node
            # information queries (type 139).  See RFC 4890, section
            # 4.4.
            ip6tables -A INPUT -p icmpv6 --icmpv6-type redirect -j DROP
            ip6tables -A INPUT -p icmpv6 --icmpv6-type 139 -j DROP
            ip6tables -A INPUT -p icmpv6 -j ACCEPT

            # Reject/drop everything else.
            ip46tables -A INPUT -j FW_REFUSE
          '';

        postStop =
          ''
            iptables -F INPUT
            iptables -P INPUT ACCEPT
            ip6tables -F INPUT
            ip6tables -P INPUT ACCEPT
          '';
      };

  };

}
