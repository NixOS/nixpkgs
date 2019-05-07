{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.pazi;
in
{
  options = {
    programs.pazi = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable pazi.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.pazi ];

    programs.bash.interactiveShellInit = "source ${pkgs.pazi}/share/pazi.bash";
    programs.fish.interactiveShellInit = "source ${pkgs.pazi}/share/pazi.fish";
    programs.zsh.interactiveShellInit = "source ${pkgs.pazi}/share/pazi.zsh";
  };
}
