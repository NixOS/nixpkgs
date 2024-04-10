{ pkgs, config, lib, ... }:

let
  inherit (lib) maintainers;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkAfter mkIf mkRemovedOptionModule;
  inherit (lib.options) mkEnableOption mkPackageOption;
  inherit (lib.strings) optionalString;

  cfg = config.programs.fzf;

in
{
  imports = [
    (mkRemovedOptionModule [ "programs" "fzf" "keybindings" ] ''
      Use "programs.fzf.enable" instead; due to fzf upstream changes, it's not possible to load shell-completion and keybindings separately.
      If you want to change/disable certain keybindings, please check the fzf documentation.
    '')
    (mkRemovedOptionModule [ "programs" "fzf" "fuzzyCompletion" ] ''
      Use "programs.fzf.enable" instead; due to fzf upstream changes, it's not possible to load shell-completion and keybindings separately.
      If you want to change/disable certain keybindings, please check the fzf documentation.
    '')
  ];

  options = {
    programs.fzf = {
      enable = mkEnableOption "fuzzy completion with fzf and keybindings";

      package = mkPackageOption pkgs "fzf" { };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.bash.promptPluginInit = mkAfter ''
      eval "$(${getExe cfg.package} --bash)"
    '';

    programs.fish.interactiveShellInit = ''
      ${getExe cfg.package} --fish | source
    '';

    programs.zsh = {
      interactiveShellInit = optionalString (!config.programs.zsh.ohMyZsh.enable) ''
        eval "$(${getExe cfg.package} --zsh)"
      '';

      ohMyZsh.plugins = mkIf (config.programs.zsh.ohMyZsh.enable) [ "fzf" ];
    };
  };

  meta.maintainers = with maintainers; [ laalsaas ];
}
