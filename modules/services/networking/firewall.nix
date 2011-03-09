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
          Whether to enable the firewall.
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
          Whether to respond to incoming ICMP echo requests ("pings").
        '';
    };
  
  };


  ###### implementation

  # !!! Maybe if `enable' is false, the firewall should still be built
  # but not started by default.  However, currently nixos-rebuild
  # doesn't deal with such Upstart jobs properly (it starts them if
  # they are changed, regardless of whether the start condition
  # holds).
  config = mkIf config.networking.firewall.enable {

    environment.systemPackages = [ pkgs.iptables ];

    jobs.firewall =
      { startOn = "started network-interfaces";

        path = [ pkgs.iptables ];

        preStart =
          ''
            # Helper command to manipulate both the IPv4 and IPv6 filters.
            ip46tables() {
              iptables "$@"
              ip6tables "$@"
            }

            ip46tables -F
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
              ) config.networking.firewall.allowedTCPPorts
            }

            # Accept packets on the allowed UDP ports.
            ${concatMapStrings (port:
                ''
                  ip46tables -A INPUT -p udp --dport ${toString port} -j ACCEPT
                ''
              ) config.networking.firewall.allowedUDPPorts
            }

            # Accept IPv4 multicast.  Not a big security risk since
            # probably nobody is listening anyway.
            iptables -A INPUT -d 224.0.0.0/4 -j ACCEPT

            # Accept IPv6 ICMP packets on the local link.  Otherwise
            # stuff like neighbor/router solicitation won't work.
            ip6tables -A INPUT -s fe80::/10 -p icmpv6 -j ACCEPT
            ip6tables -A INPUT -d fe80::/10 -p icmpv6 -j ACCEPT

            # Optionally respond to pings.
            ${optionalString cfg.allowPing ''
              iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
              ip6tables -A INPUT -p icmpv6 --icmpv6-type echo-request -j ACCEPT
            ''}

            # Reject/drop everything else.
            ip46tables -A INPUT -j FW_REFUSE
          '';

        postStop =
          ''
            iptables -F
            iptables -P INPUT ACCEPT
            ip6tables -F
            ip6tables -P INPUT ACCEPT
          '';
      };

  };

}
