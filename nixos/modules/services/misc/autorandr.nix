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

    systemd.packages = [ pkgs.autorandr ];

    systemd.services.autorandr = {
      wantedBy = [ "sleep.target" ];
    };

  };

}
