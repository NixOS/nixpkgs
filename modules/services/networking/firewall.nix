{pkgs, config, ...}:

let

  iptables = "${pkgs.iptables}/sbin/iptables";

in

{

  ###### interface

  options = {
  
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
  
  config = {

    environment.systemPackages = [pkgs.iptables];

    jobs = pkgs.lib.singleton
      { name = "firewall";

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

    networking.firewall.allowedTCPPorts = [22];
    
  };

}
