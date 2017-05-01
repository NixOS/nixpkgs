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

        highlighters = mkOption {
          default = [ "main" ];

          # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
          type = types.listOf(types.enum([
            "main"
            "brackets"
            "pattern"
            "cursor"
            "root"
            "line"
          ]));

          description = ''
            Specifies the highlighters to be used by zsh-syntax-highlighting.

            The following defined options can be found here:
            https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ zsh-syntax-highlighting ];

      programs.zsh.interactiveShellInit = with pkgs; with builtins; ''
        source ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        ${optionalString (length(cfg.highlighters) > 0)
          "ZSH_HIGHLIGHT_HIGHLIGHTERS=(${concatStringsSep " " cfg.highlighters})"
        }
      '';
    };
  }
