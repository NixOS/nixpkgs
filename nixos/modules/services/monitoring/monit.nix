{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.monit;
in

{
  options.services.monit = {

    enable = lib.mkEnableOption "Monit";

    config = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "monitrc content";
    };

  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.monit ];

    environment.etc.monitrc = {
      text = cfg.config;
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
      restartTriggers = [ config.environment.etc.monitrc.source ];
    };

  };

  meta.maintainers = with lib.maintainers; [ ryantm ];
}
