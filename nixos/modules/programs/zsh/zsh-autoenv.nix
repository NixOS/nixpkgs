{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.zsh-autoenv;
in {
  options = {
    programs.zsh.zsh-autoenv = {
      enable = mkEnableOption (lib.mdDoc "zsh-autoenv");
      package = mkPackageOption pkgs "zsh-autoenv" { };
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.interactiveShellInit = ''
      source ${cfg.package}/share/zsh-autoenv/autoenv.zsh
    '';
  };
}
