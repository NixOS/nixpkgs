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
        default = false;
        description = "Whether to enable the X Font Server.";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.xfs.enable (
  mkAssert config.fonts.enableFontDir "
    Please enable fontDir (fonts.enableFontDir) to use xfs.
  " {

    jobs.xfs =
      { description = "X Font Server";

        startOn = "started networking";

        exec = "${pkgs.xorg.xfs}/bin/xfs -config ${configFile}";
      };

  });

}
