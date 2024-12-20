{ config, pkgs, lib, ... }:
let

  vteInitSnippet = ''
    # Show current working directory in VTE terminals window title.
    # Supports both bash and zsh, requires interactive shell.
    . ${pkgs.vte.override { gtkVersion = null; }}/etc/profile.d/vte.sh
  '';

in

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  options = {

    programs.bash.vteIntegration = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether to enable Bash integration for VTE terminals.
        This allows it to preserve the current directory of the shell
        across terminals.
      '';
    };

    programs.zsh.vteIntegration = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether to enable Zsh integration for VTE terminals.
        This allows it to preserve the current directory of the shell
        across terminals.
      '';
    };

  };

  config = lib.mkMerge [
    (lib.mkIf config.programs.bash.vteIntegration {
      programs.bash.interactiveShellInit = lib.mkBefore vteInitSnippet;
    })

    (lib.mkIf config.programs.zsh.vteIntegration {
      programs.zsh.interactiveShellInit = vteInitSnippet;
    })
  ];
}
