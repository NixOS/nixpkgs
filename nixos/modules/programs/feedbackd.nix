{ pkgs, lib, config, ... }:

let
  cfg = config.programs.feedbackd;
in {
  options = {
    programs.feedbackd = {
      enable = lib.mkEnableOption ''
        the feedbackd D-BUS service and udev rules.

        Your user needs to be in the `feedbackd` group to trigger effects
      '';
      package = lib.mkPackageOption pkgs "feedbackd" { };
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    users.groups.feedbackd = {};
  };
}
