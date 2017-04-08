{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.autorandr;

in {

  options = {

    services.autorandr = {
      enable = mkEnableOption "handling of hotplug and sleep events by autorandr";
    };

  };

  config = mkIf cfg.enable {

    services.udev.packages = [ pkgs.autorandr ];

    environment.systemPackages = [ pkgs.autorandr ];

    # systemd.unitPackages = [ pkgs.autorandr ];
    systemd.services.autorandr = {
      unitConfig = {
        Description = "autorandr execution hook";
        After = [ "sleep.target" ];
        StartLimitInterval = "5";
        StartLimitBurst = "1";
      };
      serviceConfig = {
        ExecStart = "${pkgs.autorandr}/bin/autorandr --batch --change --default default";
        Type = "oneshot";
        RemainAfterExit = false;
      };
      wantedBy = [ "sleep.target" ];
    };

  };

}
