{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.programs.fzf;

in
{
  imports = [
    (lib.mkRemovedOptionModule [ "programs" "fzf" "keybindings" ] ''
      Use "programs.fzf.enable" instead, due to fzf upstream-change it's not possible to load shell-completion and keybindings separately.
      If you want to change/disable certain keybindings please check the fzf-documentation.
    '')
    (lib.mkRemovedOptionModule [ "programs" "fzf" "fuzzyCompletion" ] ''
      Use "programs.fzf.enable" instead, due to fzf upstream-change it's not possible to load shell-completion and keybindings separately.
      If you want to change/disable certain keybindings please check the fzf-documentation.
    '')
  ];

  options = {
    programs.fzf.enable = mkEnableOption (mdDoc "fuzzy completion with fzf and keybindings");
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.fzf ];

    programs.bash.interactiveShellInit = ''
      eval "$(${getExe pkgs.fzf} --bash)"
    '';

    programs.fish.interactiveShellInit = ''
      ${getExe pkgs.fzf} --fish | source
    '';

    programs.zsh = {
      interactiveShellInit = optionalString (!config.programs.zsh.ohMyZsh.enable) ''
        eval "$(${getExe pkgs.fzf} --zsh)"
      '';

      ohMyZsh.plugins = mkIf (config.programs.zsh.ohMyZsh.enable) [ "fzf" ];
    };
  };

  meta.maintainers = with maintainers; [ laalsaas ];
}
