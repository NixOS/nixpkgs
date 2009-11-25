{ config, pkgs, ... }:

with pkgs.lib;

let

  cfgC = config.services.synergy.client;
  cfgS = config.services.synergy.server;

in

{
  ###### interface

  options = {
  
    services.synergy = {

      # !!! All these option descriptions needs to be cleaned up.

      client = {
        enable = mkOption {
          default = false;
          description = "
            Whether to enable the synergy client (receive keyboard and mouse events from a synergy server)
          ";
        };
        screenName = mkOption {
          default = "";
          description = " 
            use screen-name instead the hostname to identify
            ourselfs to the server.
            ";
        };
      };

      server = {
        enable = mkOption {
          default = false;
          description = "
            Whether to enable the synergy server (send keyboard and mouse events)
          ";
        };
        configFile = mkOption {
          default = "/etc/synergy-server.conf";
          description = "
            The synergy server configuration file. open upstart-jobs/synergy.nix to see an example
          ";
        };
        screenName = mkOption {
          default = "";
          description = " 
            use screen-name instead the hostname to identify
            this screen in the configuration.
            ";
        };
        address = mkOption {
          default = "";
          description = "listen for clients on the given address";
        };
      };
    };

  };


  ###### implementation

  config = {

    jobs =
    
      optionalAttrs cfgC.enable
        { synergyClient = 
          { name = "synergy-client";

            description = "Synergy client";

            startOn = "started network-interfaces";
            stopOn = "stopping network-interfaces";

            exec = "${pkgs.synergy}/bin/synergyc ${if cfgS.screenName == "" then "" else "-n ${cfgS.screenName}" }";
          };
        }
        
      // optionalAttrs cfgS.enable
        { synergyServer = 
          { name = "synergy-server";

            description = "Synergy server";

            startOn = "started network-interfaces";
            stopOn = "stopping network-interfaces";

            exec =
              ''
                ${pkgs.synergy}/bin/synergys -c ${cfgS.configFile} \
                  -f ${if cfgS.address == "" then "" else "-a ${cfgS.address}"} \
                  ${if cfgS.screenName == "" then "" else "-n ${cfgS.screenName}" }
              '';
          };
        };

  };

}

/* SYNERGY SERVER example configuration file
section: screens
  laptop:
  dm:
  win:
end
section: aliases
    laptop: 
      192.168.5.5
    dm:
      192.168.5.78
    win:
      192.168.5.54
end
section: links
   laptop:
       left = dm
   dm:
       right = laptop
       left = win
  win:
      right = dm
end
*/
