# Monit system watcher
# http://mmonit.org/monit/

{config, pkgs, lib, ...}:

let inherit (lib) mkOption mkIf;
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

    systemd.services.monit = {
      description = "Pro-active monitoring utility for unix systems";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.monit}/bin/monit -I -c /etc/monit.conf";
        ExecStop = "${pkgs.monit}/bin/monit -c /etc/monit.conf quit";
        ExecReload = "${pkgs.monit}/bin/monit -c /etc/monit.conf reload";
        KillMode = "process";
        Restart = "always";
      };
    };
  };
}
