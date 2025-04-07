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
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.xivlauncher ];
  };

  meta.maintainers = with lib.maintainers; [
    sersorrel
    witchof0x20
    drakon64
  ];
}
