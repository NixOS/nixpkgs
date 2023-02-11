{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.zsh-autoenv;
in {
  options = {
    programs.zsh.zsh-autoenv = {
      enable = mkEnableOption (lib.mdDoc "zsh-autoenv");
      package = mkOption {
        default = pkgs.zsh-autoenv;
        defaultText = literalExpression "pkgs.zsh-autoenv";
        description = lib.mdDoc ''
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
