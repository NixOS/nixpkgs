{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.amule;
  user = if cfg.user != null then cfg.user else "amule";
in

{

  ###### interface

  options = {
  
    services.amule = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run the AMule daemon. You need to manually run "amuled --ec-config" to configure the service for the first time.
        '';
      };

      dataDir = mkOption {
        default = ''/home/${user}/'';
        description = ''
          The directory holding configuration, incoming and temporary files.
        '';
      };

      user = mkOption {
        default = null;
        description = ''
          The user the AMule daemon should run as.
        '';
      };

    };

  };
  

  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = mkIf (cfg.user == null) [
      { name = cfg.user;
        description = "AMule daemon";
      } ];

    jobs.amuled =
      { description = "AMule daemon";

        startOn = "ip-up";

        preStart = ''
            mkdir -p ${cfg.dataDir}
            chown ${user} ${cfg.dataDir}
        '';

        exec = ''
            ${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} ${user} \
                -c 'HOME="${cfg.dataDir}" ${pkgs.amuleDaemon}/bin/amuled'
        '';
      };

  };
  
}
