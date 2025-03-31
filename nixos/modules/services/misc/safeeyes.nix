{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.safeeyes;

in

{

  ###### interface

  options = {

    services.safeeyes = {

      enable = lib.mkEnableOption "the safeeyes OSGi service";

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.safeeyes ];

    systemd.user.services.safeeyes = {
      description = "Safeeyes";

      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      startLimitIntervalSec = 350;
      startLimitBurst = 10;
      serviceConfig = {
        ExecStart = ''
          ${pkgs.safeeyes}/bin/safeeyes
        '';
        Restart = "on-failure";
        RestartSec = 3;
      };
    };

  };
}
