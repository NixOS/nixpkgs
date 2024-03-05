{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.programs.feedbackd;
in {
  options = {
    programs.feedbackd = {
      enable = mkEnableOption (lib.mdDoc ''
        the feedbackd D-BUS service and udev rules.

        Your user needs to be in the `feedbackd` group to trigger effects
      '');
      package = mkPackageOption pkgs "feedbackd" { };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    users.groups.feedbackd = {};
  };
}
