{ pkgs, config, lib, ... }:
let
  inherit (lib) mdDoc mkEnableOption mkPackageOption optional optionalString;
  cfg = config.programs.skim;
in
{
  options = {
    programs.skim = {
      fuzzyCompletion = mkEnableOption (mdDoc "fuzzy completion with skim");
      keybindings = mkEnableOption (mdDoc "skim keybindings");
      package = mkPackageOption pkgs "skim" {};
    };
  };

  config = {
    environment.systemPackages = optional (cfg.keybindings || cfg.fuzzyCompletion) cfg.package;

    programs.bash.interactiveShellInit = optionalString cfg.fuzzyCompletion ''
      source ${cfg.package}/share/skim/completion.bash
    '' + optionalString cfg.keybindings ''
      source ${cfg.package}/share/skim/key-bindings.bash
    '';

    programs.zsh.interactiveShellInit = optionalString cfg.fuzzyCompletion ''
      source ${cfg.package}/share/skim/completion.zsh
    '' + optionalString cfg.keybindings ''
      source ${cfg.package}/share/skim/key-bindings.zsh
    '';

    programs.fish.interactiveShellInit = optionalString cfg.keybindings ''
      source ${cfg.package}/share/skim/key-bindings.fish && skim_key_bindings
    '';
  };
}
