{ config, lib, pkgs, ... }:

let
  cfg = config.services.iio-sensor-proxy;
in {
  options = {
    services.iio-sensor-proxy = {
      enable = lib.mkEnableOption "iio-sensor-proxy";
    };
  };

  config = lib.mkIf cfg.enable {
    services.dbus.packages = [ pkgs.iio-sensor-proxy ];
    services.udev.packages = [ pkgs.iio-sensor-proxy ];
    systemd.packages = [ pkgs.iio-sensor-proxy ];
  };
}
