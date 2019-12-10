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

    enable = mkEnableOption "zsh-autosuggestions";

    highlightStyle = mkOption {
      type = types.str;
      default = "fg=8"; # https://github.com/zsh-users/zsh-autosuggestions/tree/v0.4.3#suggestion-highlight-style
      description = "Highlight style for suggestions ({fore,back}ground color)";
      example = "fg=cyan";
    };

    strategy = mkOption {
      type = types.enum [ "history" "match_prev_cmd" ];
      default = "history";
      description = ''
        Set ZSH_AUTOSUGGEST_STRATEGY to choose the strategy for generating suggestions.
        There are currently two to choose from:

          * history: Chooses the most recent match.
          * match_prev_cmd: Chooses the most recent match whose preceding history item matches
            the most recently executed command (more info). Note that this strategy won't work as
            expected with ZSH options that don't preserve the history order such as
            HIST_IGNORE_ALL_DUPS or HIST_EXPIRE_DUPS_FIRST.
      '';
    };

    extraConfig = mkOption {
      type = with types; attrsOf str;
      default = {};
      description = "Attribute set with additional configuration values";
      example = literalExample ''
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
      export ZSH_AUTOSUGGEST_STRATEGY=("${cfg.strategy}")

      ${concatStringsSep "\n" (mapAttrsToList (key: value: ''export ${key}="${value}"'') cfg.extraConfig)}
    '';

  };
}
