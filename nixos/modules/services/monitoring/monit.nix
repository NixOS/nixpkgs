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
        description = "monitrc content";
      };
    };
  };

  config = mkIf config.services.monit.enable {

    environment.systemPackages = [ pkgs.monit ];

    environment.etc."monitrc" = {
      text = config.services.monit.config;
      mode = "0400";
    };

    systemd.services.monit = {
      description = "Pro-active monitoring utility for unix systems";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.monit}/bin/monit -I -c /etc/monitrc";
        ExecStop = "${pkgs.monit}/bin/monit -c /etc/monitrc quit";
        ExecReload = "${pkgs.monit}/bin/monit -c /etc/monitrc reload";
        KillMode = "process";
        Restart = "always";
      };
      restartTriggers = [ config.environment.etc."monitrc".source ];
    };

  };
}
