{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.pazi;
  prg = config.programs;

  initScript = shell: ''
    eval $(${pkgs.pazi}/bin/pazi init ${shell})
  '';
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

    programs.bash.interactiveShellInit = initScript "bash";
    programs.zsh.interactiveShellInit = mkIf prg.zsh.enable initScript "zsh";
    programs.fish.interactiveShellInit = mkIf prg.fish.enable ''
      ${pkgs.pazi}/bin/pazi init fish | source
    '';
  };
}
