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
            ourselves to the server.
            ";
        };
        serverAddress = mkOption {
          description = "
            The server address is of the form: [hostname][:port].  The
            hostname must be the address or hostname of the server.  The
            port overrides the default port, 24800.
          ";
        };
        autoStart = mkOption {
          default = true;
          type = types.bool;
          description = "Whether synergy-client should be started automatically.";
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
        autoStart = mkOption {
          default = true;
          type = types.bool;
          description = "Whether synergy-server should be started automatically.";
        };
      };
    };

  };


  ###### implementation

  config = {

    systemd.services."synergy-client" = mkIf cfgC.enable {
      after = [ "network.target" ];
      description = "Synergy client";
      wantedBy = optional cfgC.autoStart "multi-user.target";
      path = [ pkgs.synergy ];
      serviceConfig.ExecStart = ''${pkgs.synergy}/bin/synergyc -f ${optionalString (cfgC.screenName != "") "-n ${cfgC.screenName}"} ${cfgC.serverAddress}'';
    };

    systemd.services."synergy-server" = mkIf cfgS.enable {
      after = [ "network.target" ];
      description = "Synergy server";
      wantedBy = optional cfgS.autoStart "multi-user.target";
      path = [ pkgs.synergy ];
      serviceConfig.ExecStart = ''${pkgs.synergy}/bin/synergys -c ${cfgS.configFile} -f ${optionalString (cfgS.address != "") "-a ${cfgS.address}"} ${optionalString (cfgS.screenName != "") "-n ${cfgS.screenName}" }'';
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
