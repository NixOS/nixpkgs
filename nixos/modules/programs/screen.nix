{ config, pkgs, ... }:

let
  inherit (pkgs.lib) mkOption mkIf types;
  cfg = config.programs.screen;
in

{
  ###### interface

  options = {
    programs.screen = {

      screenrc = mkOption {
        default = "";
        description = ''
          The contents of /etc/screenrc file.
        '';
        type = types.lines;
      };
    };
  };

  ###### implementation

  config = mkIf (cfg.screenrc != "") {
    environment.etc."screenrc".text = cfg.screenrc;
  };

}
