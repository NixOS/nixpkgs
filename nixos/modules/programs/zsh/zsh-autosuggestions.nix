{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.zsh.autosuggestions;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [
        "programs"
        "zsh"
        "enableAutosuggestions"
      ]
      [
        "programs"
        "zsh"
        "autosuggestions"
        "enable"
      ]
    )
  ];

  options.programs.zsh.autosuggestions = {

    enable = lib.mkEnableOption "zsh-autosuggestions";

    highlightStyle = lib.mkOption {
      type = lib.types.str;
      default = "fg=8"; # https://github.com/zsh-users/zsh-autosuggestions/tree/v0.4.3#suggestion-highlight-style
      description = "Highlight style for suggestions ({fore,back}ground color)";
      example = "fg=cyan";
    };

    strategy = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "history"
          "completion"
          "match_prev_cmd"
        ]
      );
      default = [ "history" ];
      description = ''
        `ZSH_AUTOSUGGEST_STRATEGY` is an array that specifies how suggestions should be generated.
        The strategies in the array are tried successively until a suggestion is found.
        There are currently three built-in strategies to choose from:

        - `history`: Chooses the most recent match from history.
        - `completion`: Chooses a suggestion based on what tab-completion would suggest. (requires `zpty` module)
        - `match_prev_cmd`: Like `history`, but chooses the most recent match whose preceding history item matches
            the most recently executed command. Note that this strategy won't work as expected with ZSH options that
            don't preserve the history order such as `HIST_IGNORE_ALL_DUPS` or `HIST_EXPIRE_DUPS_FIRST`.
      '';
    };

    async = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to fetch suggestions asynchronously";
      example = false;
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Attribute set with additional configuration values";
      example = lib.literalExpression ''
        {
          "ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE" = "20";
        }
      '';
    };

  };

  config = lib.mkIf cfg.enable {

    programs.zsh.interactiveShellInit = ''
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="${cfg.highlightStyle}"
      export ZSH_AUTOSUGGEST_STRATEGY=(${builtins.concatStringsSep " " cfg.strategy})
      ${lib.optionalString (!cfg.async) "unset ZSH_AUTOSUGGEST_USE_ASYNC"}

      ${builtins.concatStringsSep "\n" (
        lib.mapAttrsToList (key: value: ''export ${key}="${value}"'') cfg.extraConfig
      )}
    '';

  };
}
