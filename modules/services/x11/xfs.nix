{ config, pkgs, ... }:

with pkgs.lib;

let

  configFile = ./xfs.conf;
  
  startingDependency =
    if config.services.gw6c.enable && config.services.gw6c.autorun
    then "gw6c"
    else "network-interfaces";
  
in

{

  ###### interface

  options = {
  
    services.xfs = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the X Font Server.";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.xfs.enable {

    assertions = singleton
      { assertion = config.fonts.enableFontDir;
        message = "Please enable fontDir (fonts.enableFontDir) to use xfs.";
      };

    jobs.xfs =
      { description = "X Font Server";
      
        startOn = "started ${startingDependency}";

        exec = "${pkgs.xorg.xfs}/bin/xfs -config ${configFile}";
      };

  };
  
}
