# VTE

{ config, pkgs, lib, ... }:

with lib;

let

  vteInitSnippet = ''
    # Show current working directory in VTE terminals window title.
    # Supports both bash and zsh, requires interactive shell.
    . ${pkgs.vte}/etc/profile.d/vte.sh
  '';

in

{

  options = {

    programs.bash.vteIntegration = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable Bash integration for VTE terminals.
        This allows it to preserve the current directory of the shell
        across terminals.
      '';
    };

    programs.zsh.vteIntegration = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable Zsh integration for VTE terminals.
        This allows it to preserve the current directory of the shell
        across terminals.
      '';
    };

  };

  config = mkMerge [
    (mkIf config.programs.bash.vteIntegration {
      programs.bash.interactiveShellInit = vteInitSnippet;
    })

    (mkIf config.programs.zsh.vteIntegration {
      programs.zsh.interactiveShellInit = vteInitSnippet;
    })
  ];
}
