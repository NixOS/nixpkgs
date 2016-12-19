{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fluentd;
in {
  ###### interface

  options = {

    services.fluentd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable fluentd.";
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = "Fluentd config.";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.fluentd = with pkgs; {
      description = "Fluentd Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.fluentd}/bin/fluentd -c ${pkgs.writeText "fluentd.conf" cfg.config}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
