{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.services.ddccontrol;
in

{
  ###### interface

  options = {
    services.ddccontrol = {
      enable = lib.mkEnableOption "ddccontrol for controlling displays";
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    # Load the i2c-dev module
    boot.kernelModules = [ "i2c_dev" ];

    # Give users access to the "gddccontrol" tool
    environment.systemPackages = [
      pkgs.ddccontrol
    ];

    services.dbus.packages = [
      pkgs.ddccontrol
    ];

    systemd.packages = [
      pkgs.ddccontrol
    ];
  };
}
