{ config, lib, pkgs, ... }:

let
  cfg = config.programs.zsh-history;
in
{

  options.programs.zsh-history = {
    enable = lib.mkEnableOption "A CLI to provide enhanced history for your shell";
  };

  config = lib.mkIf cfg.enable {
    meta.maintainers = with lib.maintainers; [ kampka ];

    environment.systemPackages = [ pkgs.zsh-history ];

    programs.zsh.interactiveShellInit = ''
      source ${pkgs.zsh-history.out}/share/zsh/init.zsh
    '';
  };
}
