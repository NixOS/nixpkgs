{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.skim;
in
{
  options = {
    programs.skim = {
      fuzzyCompletion = lib.mkEnableOption "fuzzy completion with skim";
      keybindings = lib.mkEnableOption "skim keybindings";
      package = lib.mkPackageOption pkgs "skim" { };
    };
  };

  config = {
    environment.systemPackages = lib.optional (cfg.keybindings || cfg.fuzzyCompletion) cfg.package;

    programs.bash.interactiveShellInit =
      lib.optionalString cfg.fuzzyCompletion ''
        source ${cfg.package}/share/skim/completion.bash
      ''
      + lib.optionalString cfg.keybindings ''
        source ${cfg.package}/share/skim/key-bindings.bash
      '';

    programs.zsh.interactiveShellInit =
      lib.optionalString cfg.fuzzyCompletion ''
        source ${cfg.package}/share/skim/completion.zsh
      ''
      + lib.optionalString cfg.keybindings ''
        source ${cfg.package}/share/skim/key-bindings.zsh
      '';

    programs.fish.interactiveShellInit = lib.optionalString cfg.keybindings ''
      source ${cfg.package}/share/skim/key-bindings.fish && skim_key_bindings
    '';
  };
}
