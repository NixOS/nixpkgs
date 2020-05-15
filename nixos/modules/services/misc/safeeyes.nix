{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.safeeyes;

in

{

  ###### interface

  options = {

    services.safeeyes = {

      enable = mkEnableOption "the safeeyes OSGi service";

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.user.services.safeeyes = {
      description = "Safeeyes";

      wantedBy = [ "graphical-session.target" ];
      partOf   = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = ''
          ${pkgs.safeeyes}/bin/safeeyes
        '';
        Restart = "on-failure";
        RestartSec = 3;
        StartLimitInterval = 350;
        StartLimitBurst = 10;
      };
    };

  };
}
