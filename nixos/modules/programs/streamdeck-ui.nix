{ config, lib, pkgs, ... }:

let
  cfg = config.programs.streamdeck-ui;
in
{
  options.programs.streamdeck-ui = {
    enable = lib.mkEnableOption "streamdeck-ui";

    autoStart = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether streamdeck-ui should be started automatically.";
    };

    package = lib.mkPackageOption pkgs "streamdeck-ui" {
      default = [ "streamdeck-ui" ];
    };

  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      (lib.mkIf cfg.autoStart (pkgs.makeAutostartItem { name = "streamdeck-ui-noui"; package = cfg.package; }))
    ];

    services.udev.packages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ majiir ];
}
