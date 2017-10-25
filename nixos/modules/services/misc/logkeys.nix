{ config, lib, ... }:

with lib;

let
  cfg = config.services.logkeys;
in {
  options.services.logkeys = {
    enable = mkEnableOption "logkeys service";
  };

  config = mkIf cfg.enable {
    systemd.services.logkeys = {
      description = "LogKeys Keylogger Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.logkeys}/bin/logkeys -s";
        ExecStop = "${pkgs.logkeys}/bin/logkeys -k";
        Type = "forking";
      };
    };
  };
}
