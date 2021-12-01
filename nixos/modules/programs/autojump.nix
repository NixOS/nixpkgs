{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.autojump;
  prg = config.programs;
in
{
  options = {
    programs.autojump = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable autojump.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.pathsToLink = [ "/share/autojump" ];
    environment.systemPackages = [ pkgs.autojump ];

    programs.bash.interactiveShellInit = "source ${pkgs.autojump}/share/autojump/autojump.bash";
    programs.zsh.interactiveShellInit = mkIf prg.zsh.enable "source ${pkgs.autojump}/share/autojump/autojump.zsh";
    programs.fish.interactiveShellInit = mkIf prg.fish.enable "source ${pkgs.autojump}/share/autojump/autojump.fish";
  };
}
