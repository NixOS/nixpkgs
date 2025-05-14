{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.git-worktree-switcher;

  initScript =
    shell:
    if (shell == "fish") then
      ''
        ${lib.getExe pkgs.git-worktree-switcher} init ${shell} | source
      ''
    else
      ''
        eval "$(${lib.getExe pkgs.git-worktree-switcher} init ${shell})"
      '';
in
{
  options = {
    programs.git-worktree-switcher = {
      enable = lib.mkEnableOption "git-worktree-switcher, switch between git worktrees with speed.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git-worktree-switcher ];

    programs.bash.interactiveShellInit = initScript "bash";
    programs.zsh.interactiveShellInit = lib.optionalString config.programs.zsh.enable (
      initScript "zsh"
    );
    programs.fish.interactiveShellInit = lib.optionalString config.programs.fish.enable (
      initScript "fish"
    );
  };
}
