{ config, lib, pkgs, ... }:

with lib;

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
        description = lib.mdDoc "Whether to enable the X Font Server.";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.xfs.enable {
    assertions = singleton
      { assertion = config.fonts.enableFontDir;
        message = "Please enable fonts.enableFontDir to use the X Font Server.";
      };

    systemd.services.xfs = {
      description = "X Font Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.xorg.xfs ];
      script = "xfs -config ${configFile}";
    };
  };
}
