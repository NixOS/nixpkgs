{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  # Shorter name to access final settings a
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.services.busybar-manager;
in
{
  # Declare what settings a user of this "busybar-manager.nix" module CAN SET.
  options.services.busybar-manager = {
    enable = mkEnableOption "busybar-manager service";
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "busybar-manager.nix" module ENABLED this module
  # by setting "services.busybar-manager.enable = true;".
  config = mkIf cfg.enable {
    systemd.services.busybar-manager = {
      wantedBy = [ "multi-user.target" ];
      environment = {
        BUSYBAR_MANAGER_ROOT = "/var/lib/busybar-manager";
        BUSYBAR_MANAGER_CONFIG = "/var/lib/busybar-manager/config.json";
        BUSYBAR_MANAGER_APPS_DIR = "/var/lib/busybar-manager/apps";
      };
      serviceConfig = {
        StateDirectory = "busybar-manager";
        WorkingDirectory = "/var/lib/busybar-manager";
        ExecStart = "${pkgs.busybar-manager}/bin/busybar-manager";
      };
    };
  };
}
