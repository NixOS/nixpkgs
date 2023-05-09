{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.fzf;
in
{
  options = {
    programs.fzf = {
      fuzzyCompletion = mkEnableOption (mdDoc "fuzzy completion with fzf");
      keybindings = mkEnableOption (mdDoc "fzf keybindings");
    };
  };
  config = {
    environment.systemPackages = optional (cfg.keybindings || cfg.fuzzyCompletion) pkgs.fzf;

    programs.bash.interactiveShellInit = optionalString cfg.fuzzyCompletion ''
      source ${pkgs.fzf}/share/fzf/completion.bash
    '' + optionalString cfg.keybindings ''
      source ${pkgs.fzf}/share/fzf/key-bindings.bash
    '';

    programs.zsh.interactiveShellInit = optionalString (!config.programs.zsh.ohMyZsh.enable)
      (optionalString cfg.fuzzyCompletion ''
        source ${pkgs.fzf}/share/fzf/completion.zsh
      '' + optionalString cfg.keybindings ''
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      '');

    programs.zsh.ohMyZsh.plugins = lib.mkIf (cfg.keybindings || cfg.fuzzyCompletion) [ "fzf" ];
  };
  meta.maintainers = with maintainers; [ laalsaas ];
}
