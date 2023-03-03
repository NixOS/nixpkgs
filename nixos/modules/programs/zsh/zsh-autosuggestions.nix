{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.zsh.autosuggestions;
in
{
  imports = [
    (mkRenamedOptionModule [ "programs" "zsh" "enableAutosuggestions" ] [ "programs" "zsh" "autosuggestions" "enable" ])
  ];

  options.programs.zsh.autosuggestions = {

    enable = mkEnableOption (lib.mdDoc "zsh-autosuggestions");

    highlightStyle = mkOption {
      type = types.str;
      default = "fg=8"; # https://github.com/zsh-users/zsh-autosuggestions/tree/v0.4.3#suggestion-highlight-style
      description = lib.mdDoc "Highlight style for suggestions ({fore,back}ground color)";
      example = "fg=cyan";
    };

    strategy = mkOption {
      type = types.listOf (types.enum [ "history" "completion" "match_prev_cmd" ]);
      default = [ "history" ];
      description = lib.mdDoc ''
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

    async = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc "Whether to fetch suggestions asynchronously";
      example = false;
    };

    extraConfig = mkOption {
      type = with types; attrsOf str;
      default = {};
      description = lib.mdDoc "Attribute set with additional configuration values";
      example = literalExpression ''
        {
          "ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE" = "20";
        }
      '';
    };

  };

  config = mkIf cfg.enable {

    programs.zsh.interactiveShellInit = ''
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="${cfg.highlightStyle}"
      export ZSH_AUTOSUGGEST_STRATEGY=(${concatStringsSep " " cfg.strategy})
      ${optionalString (!cfg.async) "unset ZSH_AUTOSUGGEST_USE_ASYNC"}

      ${concatStringsSep "\n" (mapAttrsToList (key: value: ''export ${key}="${value}"'') cfg.extraConfig)}
    '';

  };
}
