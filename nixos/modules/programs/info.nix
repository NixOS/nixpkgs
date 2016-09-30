{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    programs.info.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable info pages and the <command>info</command> command.
      '';
    };

  };


  config = mkIf config.programs.info.enable {

    environment.systemPackages = [ pkgs.texinfoInteractive ];

    environment.pathsToLink = [ "/info" "/share/info" ];

    environment.extraOutputsToInstall = [ "info" ];

  };

}
