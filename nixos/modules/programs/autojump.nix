{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.autojump;

in

{

  ###### interface

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
  };
}
