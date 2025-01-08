{
  config,
  lib,
  pkgs,
  ...
}:

let

  configFile = ./xfs.conf;

in

{

  ###### interface

  options = {

    services.xfs = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the X Font Server.";
      };

    };

  };

  ###### implementation

  config = lib.mkIf config.services.xfs.enable {
    assertions = lib.singleton {
      assertion = config.fonts.enableFontDir;
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
