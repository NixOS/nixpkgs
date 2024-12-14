{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.freeradius;

  freeradiusService = cfg: {
    description = "FreeRadius server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    wants = [ "network.target" ];
    preStart = ''
      ${cfg.package}/bin/radiusd -C -d ${cfg.configDir} -l stdout
    '';

    serviceConfig = {
      ExecStart =
        "${cfg.package}/bin/radiusd -f -d ${cfg.configDir} -l stdout" + lib.optionalString cfg.debug " -xx";
      ExecReload = [
        "${cfg.package}/bin/radiusd -C -d ${cfg.configDir} -l stdout"
        "${pkgs.coreutils}/bin/kill -HUP $MAINPID"
      ];
      User = "radius";
      ProtectSystem = "full";
      ProtectHome = "on";
      Restart = "on-failure";
      RestartSec = 2;
      LogsDirectory = "radius";
    };
  };

  freeradiusConfig = {
    enable = lib.mkEnableOption "the freeradius server";

    package = lib.mkPackageOption pkgs "freeradius" { };

    configDir = lib.mkOption {
      type = lib.types.path;
      default = "/etc/raddb";
      description = ''
        The path of the freeradius server configuration directory.
      '';
    };

    debug = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable debug logging for freeradius (-xx
        option). This should not be left on, since it includes
        sensitive data such as passwords in the logs.
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

  config = lib.mkIf (cfg.enable) {

    users = {
      users.radius = {
        # uid = config.ids.uids.radius;
        description = "Radius daemon user";
        isSystemUser = true;
        group = "radius";
      };
      groups.radius = { };
    };

    systemd.services.freeradius = freeradiusService cfg;
    warnings = lib.optional cfg.debug "Freeradius debug logging is enabled. This will log passwords in plaintext to the journal!";

  };

}
