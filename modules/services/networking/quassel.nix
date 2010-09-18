{ config, pkgs, ... }:

with pkgs.lib;

let
  quassel = pkgs.quasselDaemon;
  cfg = config.services.quassel;
in

{

  ###### interface

  options = {
  
    services.quassel = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run the Quassel IRC client daemon.
        '';
      };

      interface = mkOption {
        default = "127.0.0.1";
        description = ''
          The interface the Quassel daemon will be listening to.  If `127.0.0.1',
          only clients on the local host can connect to it; if `0.0.0.0', clients
          can access it from any network interface.
        '';
      };

      portNumber = mkOption {
        default = 4242;
        description = ''
          The port number the Quassel daemon will be listening to.
        '';
      };

      logFile = mkOption {
        default = "/var/log/quassel.log";
        description = "Location of the logfile of the Quassel daemon.";
      };

      dataDir = mkOption {
        default = ''/home/${cfg.user}/.config/quassel-irc.org'';
        description = ''
          The directory holding configuration files, the SQlite database and the SSL Cert.
        '';
      };

      user = mkOption {
        default = "quassel";
        description = ''
          The user the Quassel daemon should run as.
        '';
      };

    };

  };
  

  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton
      { name = cfg.user;
        description = "Quassel IRC client daemon";
      };
    

    jobs.quassel =
      { description = "Quassel IRC client daemon";

        startOn = "ip-up";

        preStart = ''
            mkdir -p ${cfg.dataDir}
            chown ${cfg.user} ${cfg.dataDir}
            touch ${cfg.logFile} && chown ${cfg.user} ${cfg.logFile}
        '';

        exec = ''
            ${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} ${cfg.user} \
                -c '${quassel}/bin/quasselcore --listen=${cfg.interface}\
                    --port=${toString cfg.portNumber} --configdir=${cfg.dataDir} --logfile=${cfg.logFile}'
        '';
      };

    environment.systemPackages = [ quassel ];

  };
  
}
