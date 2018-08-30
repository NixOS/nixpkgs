{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.xss-lock;
in
{
  options.programs.xss-lock = {
    enable = mkEnableOption "xss-lock";
    lockerCommand = mkOption {
      example = "xlock";
      type = types.string;
      description = "Locker to be used with xsslock";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.xss-lock = {
      description = "XSS Lock Daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${pkgs.xss-lock}/bin/xss-lock ${cfg.lockerCommand}";
    };
  };
}
