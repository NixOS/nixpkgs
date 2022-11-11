{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.programs.fzf;
in {
  options = {
    programs.fzf = {
      fuzzyCompletion = mkOption {
        type = types.bool;
        description = lib.mdDoc "Whether to use fzf for fuzzy completion";
        default = false;
        example = true;
      };
      keybindings = mkOption {
        type = types.bool;
        description = lib.mdDoc "Whether to set up fzf keybindings";
        default = false;
        example = true;
      };
    };
  };
  config = {
    environment.systemPackages = optional (cfg.keybindings || cfg.fuzzyCompletion) pkgs.fzf;
    programs.bash.interactiveShellInit = optionalString cfg.fuzzyCompletion ''
      source ${pkgs.fzf}/share/fzf/completion.bash
    '' + optionalString cfg.keybindings ''
      source ${pkgs.fzf}/share/fzf/key-bindings.bash
    '';

    programs.zsh.interactiveShellInit = optionalString cfg.fuzzyCompletion ''
      source ${pkgs.fzf}/share/fzf/completion.zsh
    '' + optionalString cfg.keybindings ''
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
    '';
  };
  meta.maintainers = with maintainers; [ laalsaas ];
}
