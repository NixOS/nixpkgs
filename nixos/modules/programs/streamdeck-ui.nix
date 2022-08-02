{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.streamdeck-ui;
in {
  options.programs.streamdeck-ui = {
    enable = mkEnableOption "streamdeck-ui";

    autoStart = mkOption {
      default = true;
      type = types.bool;
      description = lib.mdDoc "Whether streamdeck-ui should be started automatically.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      streamdeck-ui
      (mkIf cfg.autoStart (makeAutostartItem { name = "streamdeck-ui"; package = streamdeck-ui; }))
    ];

    services.udev.packages = with pkgs; [ streamdeck-ui ];
  };

  meta.maintainers = with maintainers; [ majiir ];
}
