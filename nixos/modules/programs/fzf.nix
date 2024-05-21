{ pkgs, config, lib, ... }:

let
  cfg = config.programs.fzf;
in
{
  options = {
    programs.fzf = {
      fuzzyCompletion = lib.mkEnableOption "fuzzy completion with fzf";
      keybindings = lib.mkEnableOption "fzf keybindings";
    };
  };

  config = lib.mkIf (cfg.keybindings || cfg.fuzzyCompletion) {
    environment.systemPackages = lib.mkIf (cfg.keybindings || cfg.fuzzyCompletion) [ pkgs.fzf ];

    programs = {
      # load after programs.bash.enableCompletion
      bash.promptPluginInit = lib.mkAfter (lib.optionalString cfg.fuzzyCompletion ''
        source ${pkgs.fzf}/share/fzf/completion.bash
      '' + lib.optionalString cfg.keybindings ''
        source ${pkgs.fzf}/share/fzf/key-bindings.bash
      '');

      zsh = {
        interactiveShellInit = lib.optionalString (!config.programs.zsh.ohMyZsh.enable)
        (lib.optionalString cfg.fuzzyCompletion ''
          source ${pkgs.fzf}/share/fzf/completion.zsh
        '' + lib.optionalString cfg.keybindings ''
          source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        '');

        ohMyZsh.plugins = lib.mkIf config.programs.zsh.ohMyZsh.enable [ "fzf" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ laalsaas ];
}
