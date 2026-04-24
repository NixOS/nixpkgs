{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ghost-complete;

  shellDir = "${cfg.package}/share/ghost-complete/shell";
in
{
  options.programs.ghost-complete = {
    enable = lib.mkEnableOption "ghost-complete";

    package = lib.mkPackageOption pkgs "ghost-complete" { };

    enableBashIntegration = lib.mkEnableOption "Bash integration" // {
      default = config.programs.bash.enable;
      defaultText = lib.literalExpression "config.programs.bash.enable";
    };

    enableZshIntegration = lib.mkEnableOption "Zsh integration" // {
      default = config.programs.zsh.enable;
      defaultText = lib.literalExpression "config.programs.zsh.enable";
    };

    enableFishIntegration = lib.mkEnableOption "Fish integration" // {
      default = config.programs.fish.enable;
      defaultText = lib.literalExpression "config.programs.fish.enable";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # `init.zsh` must run as early as possible in `/etc/zshrc` because on a
    # supported terminal it `exec`s the ghost-complete binary to wrap the
    # shell in a PTY proxy. Anything before it in the first-pass shell init
    # is wasted; anything after is never reached. The spawned child zsh
    # re-enters `/etc/zshrc` with `GHOST_COMPLETE_ACTIVE=1` set, which the
    # guard inside `init.zsh` uses to short-circuit on the second pass.
    #
    # `ghost-complete.zsh` installs OSC 133 / 7771 prompt markers, OSC 7
    # cwd reporting, and a `zle-line-pre-redraw` buffer hook, so it must
    # run after the user's prompt/zle configuration is in place.
    programs.zsh.interactiveShellInit = lib.mkIf cfg.enableZshIntegration (
      lib.mkMerge [
        (lib.mkBefore "source ${shellDir}/init.zsh")
        (lib.mkAfter "source ${shellDir}/ghost-complete.zsh")
      ]
    );

    programs.bash.interactiveShellInit = lib.mkIf cfg.enableBashIntegration ''
      source ${shellDir}/ghost-complete.bash
    '';

    programs.fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration ''
      source ${shellDir}/ghost-complete.fish
    '';
  };

  meta.maintainers = cfg.package.meta.maintainers;
}
