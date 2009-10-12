{ config, pkgs, ... }:

with pkgs.lib;

let

  iptables = "${pkgs.iptables}/sbin/iptables";

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
      example = [22 80];
      type = types.list types.int;
      description =
        ''
          List of TCP ports on which incoming connections are
          accepted.
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

    environment.systemPackages = [pkgs.iptables];

    jobs.firewall =
      { startOn = "network-interfaces/started";

        preStart =
          ''
            ${iptables} -F

            # Accept all traffic on the loopback interface.
            ${iptables} -A INPUT -i lo -j ACCEPT

            # Accept packets from established or related connections.
            ${iptables} -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

            # Accept connections to the allowed TCP ports.            
            ${concatMapStrings (port:
                ''
                  ${iptables} -A INPUT -p tcp --dport ${toString port} -j ACCEPT
                ''
              ) config.networking.firewall.allowedTCPPorts
            }

            # Accept multicast.  Not a big security risk since
            # probably nobody is listening anyway.
            ${iptables} -A INPUT -d 224.0.0.0/4 -j ACCEPT

            # Drop everything else.
            ${optionalString cfg.logRefusedConnections ''
              ${iptables} -A INPUT -p tcp --syn -j LOG --log-level info --log-prefix "rejected connection: "
            ''}
            ${optionalString cfg.logRefusedPackets ''
              ${iptables} -A INPUT -j LOG --log-level info --log-prefix "rejected packet: "
            ''}
            ${iptables} -A INPUT -j ${if cfg.rejectPackets then "REJECT" else "DROP"}
          '';

        postStop =
          ''
            ${iptables} -F
          '';     
      };

  };

}
