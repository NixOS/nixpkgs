{ config, pkgs, ... }:

with pkgs.lib;

let

  configFile = ./xfs.conf;

in

{

  ###### interface

  options = {

    services.xfs = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the X Font Server.";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.xfs.enable {

    assertions = singleton
      { assertion = config.fonts.enableFontDir;
        message = "Please enable fonts.enableFontDir to use the X Font Server.";
      };

    jobs.xfs =
      { description = "X Font Server";

        startOn = "started networking";

        exec = "${pkgs.xorg.xfs}/bin/xfs -config ${configFile}";
      };

  };

}
