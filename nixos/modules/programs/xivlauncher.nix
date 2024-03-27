{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.xivlauncher;
  gamemodeCfg = config.programs.gamemode;
in {
  options.programs.xivlauncher = {
    enable = mkEnableOption (lib.mdDoc "Custom launcher for FFXIV");
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.xivlauncher ];

    nixpkgs.config.xivlauncher.useGamemode = (if gamemodeCfg.enable then true else false);
  };
}
