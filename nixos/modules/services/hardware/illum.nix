{ config, lib, pkgs, ... }:
let
  cfg = config.services.illum;
in {

  options = {

    services.illum = {

      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable illum, a daemon for controlling screen brightness with brightness buttons.
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    systemd.services.illum = {
      description = "Backlight Adjustment Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.illum}/bin/illum-d";
      serviceConfig.Restart = "on-failure";
    };

  };

}
