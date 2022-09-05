{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.safeeyes;

in

{

  ###### interface

  options = {

    services.safeeyes = {

      enable = mkEnableOption (lib.mdDoc "the safeeyes OSGi service");

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.safeeyes ];

    systemd.user.services.safeeyes = {
      description = "Safeeyes";

      wantedBy = [ "graphical-session.target" ];
      partOf   = [ "graphical-session.target" ];

      path = [ pkgs.alsa-utils ];

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
