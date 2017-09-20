{ config, lib, pkgs, ... }:

with lib;

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
            Whether to enable the Synergy client (receive keyboard and mouse events from a Synergy server).
          ";
        };
        screenName = mkOption {
          default = "";
          description = ''
            Use the given name instead of the hostname to identify
            ourselves to the server.
          '';
        };
        serverAddress = mkOption {
          description = ''
            The server address is of the form: [hostname][:port].  The
            hostname must be the address or hostname of the server.  The
            port overrides the default port, 24800.
          '';
        };
        autoStart = mkOption {
          default = true;
          type = types.bool;
          description = "Whether the Synergy client should be started automatically.";
        };
        enableCrypto = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Whether to enable SSL encryption of the Synergy connection. You
            will need to install the server certificate fingerprint(s) in
            ~/.synergy/SSL/Fingerprints/TrustedServers.txt.  Please refer to
            the synergy wiki for details.
          '';
        };
      };

      server = {
        enable = mkOption {
          default = false;
          description = ''
            Whether to enable the Synergy server (send keyboard and mouse events).
          '';
        };
        configFile = mkOption {
          default = "/etc/synergy-server.conf";
          description = "The Synergy server configuration file.";
        };
        screenName = mkOption {
          default = "";
          description = ''
            Use the given name instead of the hostname to identify
            this screen in the configuration.
          '';
        };
        address = mkOption {
          default = "";
          description = "Address on which to listen for clients.";
        };
        autoStart = mkOption {
          default = true;
          type = types.bool;
          description = "Whether the Synergy server should be started automatically.";
        };
        enableCrypto = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Whether to enable SSL encryption of the Synergy connection.  The
            service will generate an SSL keypair on first startup for each user
            and store its fingerprint in ~/.synergy/SSL/Fingerprints/Local.txt.
          '';
        };
      };
    };

  };


  ###### implementation

  config = mkMerge [
    (mkIf cfgC.enable {
      systemd.services."synergy-client" = {
        after = [ "network.target" ];
        description = "Synergy client";
        wantedBy = optional cfgC.autoStart "multi-user.target";
        path = [ pkgs.synergy ];
        serviceConfig.ExecStart =
            ''${pkgs.synergy}/bin/synergyc''
          + " --no-daemon "
          + optionalString (cfgC.screenName != "") "-n ${cfgC.screenName} "
          + optionalString (cfgC.enableCrypto)     "--enable-crypto"
          + cfgC.serverAddress;
        serviceConfig.Restart = "on-failure";
      };
    })
    (mkIf cfgS.enable {
      systemd.user.services."synergy-server" = {
        after = [ "network.target" ];
        description = "Synergy server";
        wantedBy = optional cfgS.autoStart "graphical-session.target";
        partOf = optional cfgS.autoStart "graphical-session.target";
        path = [ pkgs.synergy ];
        serviceConfig = {
          ExecStartPre = optionalString (cfgS.enableCrypto) "${pkgs.synergy}/bin/synergy-generate-certs";
          ExecStart = "${pkgs.synergy}/bin/synergys -c ${cfgS.configFile} --no-daemon"
            + optionalString (cfgS.address != "")    " -a ${cfgS.address}"
            + optionalString (cfgS.screenName != "") " -n ${cfgS.screenName}"
            + optionalString (cfgS.enableCrypto)     " --enable-crypto";
        };
        serviceConfig.Restart = "on-failure";
      };
    })
  ];

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
