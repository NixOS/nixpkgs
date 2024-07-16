{
  lib,
  config,
  pkgs,
  ...
}:
let
  this = config.services.taler.libeufin.bank;
  talerEnabled = config.services.taler.enable;
  dbName = "libeufin";
  inherit (config.services.taler) configFile;
in
{
  options.services.taler.libeufin.bank = {
    enable = lib.mkEnableOption "GNU Taler libeufin bank";
    package = lib.mkPackageOption pkgs "libeufin" { };
    debug = lib.mkEnableOption "debug logging";
  };

  config = lib.mkIf (talerEnabled && this.enable) {
    systemd.services = {
      libeufin = {
        script =
          "${this.package}/bin/libeufin-bank serve -c ${configFile}"
          + lib.optionalString this.debug " -L debug";
        serviceConfig = {
          DynamicUser = true;
          User = "libeufin";
        };
        requires = [ "libeufin-dbinit.service" ];
        after = [ "libeufin-dbinit.service" ];
        wantedBy = [ "multi-user.target" ]; # TODO slice?
      };
      libeufin-dbinit = {
        path = [ config.services.postgresql.package ];
        script =
          "${this.package}/bin/libeufin-bank dbinit -c ${configFile}"
          + lib.optionalString this.debug " -L debug";
        serviceConfig = {
          Type = "oneshot";
          DynamicUser = true;
          User = "libeufin";
        };
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
      };
    };

    services.postgresql.enable = true;
    services.postgresql.ensureDatabases = [ dbName ];
    services.postgresql.ensureUsers = [
      {
        name = dbName;
        ensureDBOwnership = true;
      }
    ];
  };
}
