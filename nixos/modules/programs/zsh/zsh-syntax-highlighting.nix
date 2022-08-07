{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.syntaxHighlighting;
in
{
  imports = [
    (mkRenamedOptionModule [ "programs" "zsh" "enableSyntaxHighlighting" ] [ "programs" "zsh" "syntaxHighlighting" "enable" ])
    (mkRenamedOptionModule [ "programs" "zsh" "syntax-highlighting" "enable" ] [ "programs" "zsh" "syntaxHighlighting" "enable" ])
    (mkRenamedOptionModule [ "programs" "zsh" "syntax-highlighting" "highlighters" ] [ "programs" "zsh" "syntaxHighlighting" "highlighters" ])
    (mkRenamedOptionModule [ "programs" "zsh" "syntax-highlighting" "patterns" ] [ "programs" "zsh" "syntaxHighlighting" "patterns" ])
  ];

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

        description = lib.mdDoc ''
          Specifies the highlighters to be used by zsh-syntax-highlighting.

          The following defined options can be found here:
          https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
        '';
      };

      patterns = mkOption {
        default = {};
        type = types.attrsOf types.str;

        example = literalExpression ''
          {
            "rm -rf *" = "fg=white,bold,bg=red";
          }
        '';

        description = lib.mdDoc ''
          Specifies custom patterns to be highlighted by zsh-syntax-highlighting.

          Please refer to the docs for more information about the usage:
          https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/pattern.md
        '';
      };
      styles = mkOption {
        default = {};
        type = types.attrsOf types.str;

        example = literalExpression ''
          {
            "alias" = "fg=magenta,bold";
          }
        '';

        description = lib.mdDoc ''
          Specifies custom styles to be highlighted by zsh-syntax-highlighting.

          Please refer to the docs for more information about the usage:
          https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ zsh-syntax-highlighting ];

    assertions = [
      {
        assertion = length(attrNames cfg.patterns) > 0 -> elem "pattern" cfg.highlighters;
        message = ''
          When highlighting patterns, "pattern" needs to be included in the list of highlighters.
        '';
      }
    ];

    programs.zsh.interactiveShellInit = with pkgs;
      lib.mkAfter (lib.concatStringsSep "\n" ([
        "source ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
      ] ++ optional (length(cfg.highlighters) > 0)
        "ZSH_HIGHLIGHT_HIGHLIGHTERS=(${concatStringsSep " " cfg.highlighters})"
        ++ optionals (length(attrNames cfg.patterns) > 0)
          (mapAttrsToList (
            pattern: design:
            "ZSH_HIGHLIGHT_PATTERNS+=('${pattern}' '${design}')"
          ) cfg.patterns)
        ++ optionals (length(attrNames cfg.styles) > 0)
          (mapAttrsToList (
            styles: design:
            "ZSH_HIGHLIGHT_STYLES[${styles}]='${design}'"
          ) cfg.styles)
      ));
  };
}
