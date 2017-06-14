{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.syntaxHighlighting;
in
  {
    options = {
      programs.zsh.syntaxHighlighting = {
        enable = mkEnableOption "zsh-syntax-highlighting";

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

        patterns = mkOption {
          default = {};
          type = types.attrsOf types.string;

          example = literalExample ''
            {
              "rm -rf *" = "fg=white,bold,bg=red";
            }
          '';

          description = ''
            Specifies custom patterns to be highlighted by zsh-syntax-highlighting.

            Please refer to the docs for more information about the usage:
            https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/pattern.md
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

        ${let
            n = attrNames cfg.patterns;
          in
            optionalString (length(n) > 0)
              (assert(elem "pattern" cfg.highlighters); (foldl (
                a: b:
                  ''
                    ${a}
                    ZSH_HIGHLIGHT_PATTERNS+=('${b}' '${attrByPath [b] "" cfg.patterns}')
                  ''
              ) "") n)
        }
      '';
    };
  }
