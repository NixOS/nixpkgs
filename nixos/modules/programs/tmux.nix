{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs.tmux;

in
{
  ###### interface

  options = {
    programs.tmux = {

      enable = mkWheneverToPkgOption {
        what = "globally configure tmux";
        package = literalPackage pkgs "pkgs.tmux";
      };

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
