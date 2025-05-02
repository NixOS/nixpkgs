{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.streamdeck-ui;
in
{
  options.programs.streamdeck-ui = {
    enable = mkEnableOption "streamdeck-ui";

    autoStart = mkOption {
      default = true;
      type = types.bool;
      description = "Whether streamdeck-ui should be started automatically.";
    };

    package = mkPackageOption pkgs "streamdeck-ui" {
      default = [ "streamdeck-ui" ];
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cfg.package
      (mkIf cfg.autoStart (makeAutostartItem { name = "streamdeck-ui-noui"; package = cfg.package; }))
    ];

    services.udev.packages = [ cfg.package ];
  };

  meta.maintainers = with maintainers; [ majiir ];
}
