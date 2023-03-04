{pkgs, config, lib, ...}:
with lib;
let
  cfg = config.programs.fzf;
in {
  imports = [
    (mkRemovedOptionModule [ "programs" "fzf" "fuzzyCompletion" ] "programs.fzf.fuzzyCompletion is now always enabled")
  ];
  options = {
    programs.fzf = {
      keybindings = mkEnableOption (mdDoc "fzf keybindings");
    };
  };
  config = {
    environment.systemPackages = optional (cfg.keybindings) pkgs.fzf;
    programs.bash.interactiveShellInit = optionalString cfg.keybindings ''
      source ${pkgs.fzf}/share/fzf/key-bindings.bash
    '';

    programs.zsh.interactiveShellInit = optionalString cfg.keybindings ''
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      # From some reason here only a function is defined, and we have to run it
      # in order to actually set the bindings.
      fzf_key_bindings
    '';
  };
  meta.maintainers = with maintainers; [ laalsaas ];
}
