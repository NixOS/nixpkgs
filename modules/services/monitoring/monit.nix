# Monit system watcher
# http://mmonit.org/monit/

{config, pkgs, ...}: 

let inherit (pkgs.lib) mkOption mkIf;
in

{
  options = {
    services.monit = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to run Monit system watcher.
        '';
      };
      config = mkOption {
        default = "";
        description = "monit.conf content";
      };
      startOn = mkOption {
        default = "network-interfaces/started";
        description = "What Monit supposes to be already present";
      };
    };
  };
  
  config = mkIf config.services.monit.enable {
    environment.etc = [
      {
        source = pkgs.writeTextFile {
          name = "monit.conf";
          text = config.services.monit.config;
        };
        target = "monit.conf";
        mode = "0400";
      }
    ];
    jobs.monit = {
      description = "Monit system watcher";
      
      startOn = config.services.monit.startOn;
      stopOn = "shutdown";

      exec = "${pkgs.monit}/bin/monit -I -c /etc/monit.conf";

      respawn = true;
    };
  };
}
