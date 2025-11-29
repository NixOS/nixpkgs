{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.zsh.syntaxHighlighting;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "programs" "zsh" "enableSyntaxHighlighting" ]
      [ "programs" "zsh" "syntaxHighlighting" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "programs" "zsh" "syntax-highlighting" "enable" ]
      [ "programs" "zsh" "syntaxHighlighting" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "programs" "zsh" "syntax-highlighting" "highlighters" ]
      [ "programs" "zsh" "syntaxHighlighting" "highlighters" ]
    )
    (lib.mkRenamedOptionModule
      [ "programs" "zsh" "syntax-highlighting" "patterns" ]
      [ "programs" "zsh" "syntaxHighlighting" "patterns" ]
    )
  ];

  options = {
    programs.zsh.syntaxHighlighting = {
      enable = lib.mkEnableOption "zsh-syntax-highlighting";

      highlighters = lib.mkOption {
        default = [ "main" ];

        # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
        type = lib.types.listOf (
          lib.types.enum [
            "main"
            "brackets"
            "pattern"
            "cursor"
            "regexp"
            "root"
            "line"
          ]
        );

        description = ''
          Specifies the highlighters to be used by zsh-syntax-highlighting.

          The following defined options can be found here:
          https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
        '';
      };

      patterns = lib.mkOption {
        default = { };
        type = lib.types.attrsOf lib.types.str;

        example = lib.literalExpression ''
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
      styles = lib.mkOption {
        default = { };
        type = lib.types.attrsOf lib.types.str;

        example = lib.literalExpression ''
          {
            "alias" = "fg=magenta,bold";
          }
        '';

        description = ''
          Specifies custom styles to be highlighted by zsh-syntax-highlighting.

          Please refer to the docs for more information about the usage:
          https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.zsh-syntax-highlighting ];

    assertions = [
      {
        assertion = cfg.patterns != { } -> builtins.elem "pattern" cfg.highlighters;
        message = ''
          When highlighting patterns, "pattern" needs to be included in the list of highlighters.
        '';
      }
    ];

    programs.zsh.interactiveShellInit = lib.mkAfter (
      lib.concatStringsSep "\n" (
        [
          "source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        ]
        ++ lib.optional (
          cfg.highlighters != [ ]
        ) "ZSH_HIGHLIGHT_HIGHLIGHTERS=(${builtins.concatStringsSep " " cfg.highlighters})"
        ++ lib.optionals (cfg.patterns != { }) (
          lib.mapAttrsToList (
            pattern: design: "ZSH_HIGHLIGHT_PATTERNS+=('${pattern}' '${design}')"
          ) cfg.patterns
        )
        ++ lib.optionals (cfg.styles != { }) (
          lib.mapAttrsToList (styles: design: "ZSH_HIGHLIGHT_STYLES[${styles}]='${design}'") cfg.styles
        )
      )
    );
  };
}
