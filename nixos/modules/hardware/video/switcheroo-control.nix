{ config, pkgs, lib, ... }:

with lib;
let
  pkg = [ pkgs.switcheroo-control ];
  cfg = config.services.switcherooControl;
in {
  options.services.switcherooControl = {
    enable = mkEnableOption (lib.mdDoc "switcheroo-control, a D-Bus service to check the availability of dual-GPU");
  };

  config = mkIf cfg.enable {
    services.dbus.packages = pkg;
    environment.systemPackages = pkg;
    systemd.packages = pkg;
    systemd.targets.multi-user.wants = [ "switcheroo-control.service" ];
  };
}
