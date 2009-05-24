
{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      synergy = {

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
  };

###### implementation

  inherit (pkgs.lib) optional;

  cfgC = (config.services.synergy.client);
  cfgS = (config.services.synergy.server);

  clientJob = {
    name = "synergy-client";

    job = ''
      description "synergy client"

      start on started network-interfaces
      stop on stopping network-interfaces

      respawn ${pkgs.synergy}/bin/synergyc ${if cfgS.screenName == "" then "" else "-n ${cfgS.screenName}" }
    '';
  };

  serverJob = {
    name = "synergy-server";

    job = ''
      description "synergy server"

      start on started network-interfaces
      stop on stopping network-interfaces

      respawn ${pkgs.synergy}/bin/synergys -c ${cfgS.configFile} \
       -f ${if cfgS.address == "" then "" else "-a ${cfgS.address}"} \
       ${if cfgS.screenName == "" then "" else "-n ${cfgS.screenName}" }
    '';
  };

in


mkIf config.services.sshd.enable {
  require = [
    options
  ];

  services = {
    extraJobs = (optional cfgS.enable serverJob) 
             ++ (optional cfgC.enable clientJob);
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
