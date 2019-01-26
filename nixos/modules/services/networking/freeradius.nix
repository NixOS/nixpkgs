{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.freeradius;

  freeradiusService = cfg:
  {
    description = "FreeRadius server";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];
    preStart = ''
      ${pkgs.freeradius}/bin/radiusd -C -d ${cfg.configDir} -l stdout
    '';

    serviceConfig = {
        ExecStart = "${pkgs.freeradius}/bin/radiusd -f -d ${cfg.configDir} -l stdout -xx";
        ExecReload = [
          "${pkgs.freeradius}/bin/radiusd -C -d ${cfg.configDir} -l stdout"
          "${pkgs.coreutils}/bin/kill -HUP $MAINPID"
        ];
        User = "radius";
        ProtectSystem = "full";
        ProtectHome = "on";
        Restart = "on-failure";
        RestartSec = 2;
    };
  };

  freeradiusConfig = {
    enable = mkEnableOption "the freeradius server";

    configDir = mkOption {
      type = types.path;
      default = "/etc/raddb";
      description = ''
        The path of the freeradius server configuration directory.
      '';
    };

  };

in

{

  ###### interface

  options = {
    services.freeradius = freeradiusConfig;
  };


  ###### implementation

  config = mkIf (cfg.enable) {

    users = {
      users.radius = {
        /*uid = config.ids.uids.radius;*/
        description = "Radius daemon user";
      };
    };

    systemd.services.freeradius = freeradiusService cfg;

  };

}
