{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.zsh-autoenv;
in {
  options = {
    programs.zsh.zsh-autoenv = {
      enable = mkEnableOption "zsh-autoenv";
      package = mkOption {
        default = pkgs.zsh-autoenv;
        defaultText = "pkgs.zsh-autoenv";
        description = ''
          Package to install for `zsh-autoenv` usage.
        '';

        type = types.package;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.interactiveShellInit = ''
      source ${cfg.package}/share/zsh-autoenv/autoenv.zsh
    '';
  };
}
