{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    programs.man.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable manual pages and the <command>man</command> command.
        This also includes "man" outputs of all <literal>systemPackages</literal>.
      '';
    };

  };


  config = mkIf config.programs.man.enable {

    environment.systemPackages = [ pkgs.man-db ];

    environment.pathsToLink = [ "/share/man" ];

    environment.extraOutputsToInstall = [ "man" ];

  };

}
