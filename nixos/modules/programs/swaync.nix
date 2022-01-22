{ config, pkgs, lib, ... }:

with lib;

let cfg = config.programs.swaync;

in
{

  options = {

    programs.swaync = {

      enable = mkEnableOption "Sway Notification Center";

      package = mkOption {
        type = types.package;
        default = pkgs.swaync;
        defaultText = literalExpression "pkgs.swaync";
        description = "SwayNotificationCenter derivation to use.";
      };

    };

  };


  config = mkIf config.programs.evince.enable {

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

  };

}
