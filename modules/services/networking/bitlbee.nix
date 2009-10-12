{ config, pkgs, ... }:

with pkgs.lib;

let

  bitlbeeUid = config.ids.uids.bitlbee;
  
  inherit (config.services.bitlbee) portNumber interface;
  
in

{

  ###### interface

  options = {
  
    services.bitlbee = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run the BitlBee IRC to other chat network gateway.
          Running it allows you to access the MSN, Jabber, Yahoo! and ICQ chat
          networks via an IRC client.
        '';
      };

      interface = mkOption {
        default = "127.0.0.1";
        description = ''
          The interface the BitlBee deamon will be listening to.  If `127.0.0.1',
          only clients on the local host can connect to it; if `0.0.0.0', clients
          can access it from any network interface.
        '';
      };

      portNumber = mkOption {
        default = 6667;
        description = ''
          Number of the port BitlBee will be listening to.
        '';
      };

    };

  };
  

  ###### implementation

  config = mkIf config.services.bitlbee.enable {

    users.extraUsers = singleton
      { name = "bitlbee";
        uid = bitlbeeUid;
        description = "BitlBee user";
        home = "/var/empty";
      };
    
    users.extraGroups = singleton
      { name = "bitlbee";
        gid = config.ids.gids.bitlbee;
      };

    jobs.bitlbee =
      { description = "BitlBee IRC to other chat networks gateway";

        startOn = "network-interfaces/started";
        stopOn = "network-interfaces/stop";

        preStart =
          ''
            if ! test -d /var/lib/bitlbee
            then
                mkdir -p /var/lib/bitlbee
                chown bitlbee:bitlbee /var/lib/bitlbee
            fi
          '';

        exec =
          ''
            ${pkgs.bitlbee}/sbin/bitlbee -F -p ${toString portNumber} \
              -i ${interface} -u bitlbee
          '';
      };

    environment.systemPackages = [ pkgs.bitlbee ];

  };
  
}
