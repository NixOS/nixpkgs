{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.programs.feedbackd;
in {
  options = {
    programs.feedbackd = {
      enable = mkEnableOption ''
        Whether to enable the feedbackd D-BUS service and udev rules.

        Your user needs to be in the `feedbackd` group to trigger effects.
      '';
      package = mkOption {
        description = lib.mdDoc ''
          Which feedbackd package to use.
        '';
        type = types.package;
        default = pkgs.feedbackd;
        defaultText = literalExpression "pkgs.feedbackd";
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    users.groups.feedbackd = {};
  };
}
