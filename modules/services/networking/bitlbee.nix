{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      bitlbee = {

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
  };
in

###### implementation

let
  bitlbeeUid = config.ids.uids.bitlbee;
  inherit (config.services.bitlbee) portNumber interface;
in

mkIf config.services.bitlbee.enable {

  require = options;

  users = {
    extraUsers = [
      { name = "bitlbee";
        uid = bitlbeeUid;
        description = "BitlBee user";
        home = "/var/empty";
      }
    ];
    
    extraGroups = [
      { name = "bitlbee";
        gid = config.ids.gids.bitlbee;
      }
    ];
  };

  services.extraJobs = [{
    name = "bitlbee";

    job = ''
      description "BitlBee IRC to other chat networks gateway"

      start on network-interfaces/started
      stop on network-interfaces/stop

      start script
          if ! test -d /var/lib/bitlbee
          then
              mkdir -p /var/lib/bitlbee
              chown bitlbee:bitlbee /var/lib/bitlbee
          fi
      end script

      respawn ${pkgs.bitlbee}/sbin/bitlbee -F -p ${toString portNumber} \
              -i ${interface} -u bitlbee
    '';
  }];

  environment.systemPackages = [ pkgs.bitlbee ];
}
