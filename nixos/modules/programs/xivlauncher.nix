{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.xivlauncher;
in
{
  options.programs.xivlauncher = {
    enable = lib.mkEnableOption "Custom launcher for FFXIV";

    enableGameMode = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.gamemode.enable;
      defaultText = lib.literalExpression "config.programs.gamemode.enable";
      description = ''
        Whether to enable GameMode to optimise system performance on demand.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ (pkgs.xivlauncher.override { useGameMode = cfg.enableGameMode; }) ];
  };

  meta.maintainers = with lib.maintainers; [
    sersorrel
    witchof0x20
    drakon64
  ];
}
