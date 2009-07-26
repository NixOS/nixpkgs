{pkgs, config, ...}:

let

  iptables = "${pkgs.iptables}/sbin/iptables";

in

{

  ###### interface

  options = {
  
    networking.firewall.enable = pkgs.lib.mkOption {
      default = false;
      description =
        ''
          Whether to enable the firewall.
        '';
    };
  
    networking.firewall.allowedTCPPorts = pkgs.lib.mkOption {
      default = [];
      example = [22 80];
      type = pkgs.lib.types.list pkgs.lib.types.int;
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
  config = pkgs.lib.mkIf config.networking.firewall.enable {

    environment.systemPackages = [pkgs.iptables];

    jobs = pkgs.lib.singleton
      { name = "firewall";

        startOn = "network-interfaces/started";

        preStart =
          ''
            ${iptables} -F

            # Accept all traffic on the loopback interface.
            ${iptables} -A INPUT -i lo -j ACCEPT

            # Accept packets from established or related connections.
            ${iptables} -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

            # Accept connections to the allowed TCP ports.            
            ${pkgs.lib.concatMapStrings (port:
                ''
                  ${iptables} -A INPUT -p tcp --dport ${toString port} -j ACCEPT
                ''
              ) config.networking.firewall.allowedTCPPorts
            }

            # Drop everything else.              
            ${iptables} -A INPUT -j DROP
          '';

        postStop =
          ''
            ${iptables} -F
          '';     
      };

  };

}
