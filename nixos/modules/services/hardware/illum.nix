{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.illum;
in {

  options = {

    services.illum = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable illum, a daemon for controlling screen brightness with brightness buttons.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    systemd.services.illum = {
      description = "Backlight Adjustment Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.illum}/bin/illum-d";
      serviceConfig.Restart = "on-failure";
    };

  };

}
