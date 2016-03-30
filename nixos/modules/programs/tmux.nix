{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkMerge types;

  cfg = config.programs.tmux;

in
{
  ###### interface

  options = {
    programs.tmux = {

      enable = mkEnableOption "<command>tmux</command> - a <command>screen</command> replacement.";

      tmuxconf = mkOption {
        default = "";
        description = ''
          The contents of /etc/tmux.conf
        '';
        type = types.lines;
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.tmux ];
      etc."tmux.conf".text = cfg.tmuxconf;
    };
  };
}
