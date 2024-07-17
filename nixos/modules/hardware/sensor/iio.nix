{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  ###### interface

  options = {
    hardware.sensor.iio = {
      enable = mkOption {
        description = ''
          Enable this option to support IIO sensors with iio-sensor-proxy.

          IIO sensors are used for orientation and ambient light
          sensors on some mobile devices.
        '';
        type = types.bool;
        default = false;
      };
    };
  };

  ###### implementation

  config = mkIf config.hardware.sensor.iio.enable {

    boot.initrd.availableKernelModules = [ "hid-sensor-hub" ];

    environment.systemPackages = with pkgs; [ iio-sensor-proxy ];

    services.dbus.packages = with pkgs; [ iio-sensor-proxy ];
    services.udev.packages = with pkgs; [ iio-sensor-proxy ];
    systemd.packages = with pkgs; [ iio-sensor-proxy ];
  };
}
