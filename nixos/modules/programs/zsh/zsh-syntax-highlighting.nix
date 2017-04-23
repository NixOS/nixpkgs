{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.syntax-highlighting;
in
  {
    options = {
      programs.zsh.syntax-highlighting = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Enable zsh-syntax-highlighting.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ zsh-syntax-highlighting ];

      program.zsh.interactiveShellInit = with pkgs; ''
        source ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      '';
    };
  }
