{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.postgresql;

  groupAccessAvailable = versionAtLeast cfg.package.version "11.0";

in
{
  config = mkIf cfg.enable {
    systemd.services.postgresql =
      { description = "PostgreSQL Server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment.PGDATA = cfg.dataDir;

        path = [ cfg.postgresqlWithExtraPlugins ];

        preStart = cfg.preStartCommands;

        # Wait for PostgreSQL to be ready to accept connections.
        postStart = cfg.postStartCommands;

        serviceConfig = mkMerge [
          { ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
            User = "postgres";
            Group = "postgres";
            RuntimeDirectory = "postgresql";
            Type = if versionAtLeast cfg.package.version "9.6"
                   then "notify"
                   else "simple";

            # Shut down Postgres using SIGINT ("Fast Shutdown mode").  See
            # http://www.postgresql.org/docs/current/static/server-shutdown.html
            KillSignal = "SIGINT";
            KillMode = "mixed";

            # Give Postgres a decent amount of time to clean up after
            # receiving systemd's SIGINT.
            TimeoutSec = 120;

            ExecStart = "${cfg.postgresqlWithExtraPlugins}/bin/postgres";
          }
          (mkIf (cfg.dataDir == "/var/lib/postgresql/${cfg.package.psqlSchema}") {
            StateDirectory = "postgresql postgresql/${cfg.package.psqlSchema}";
            StateDirectoryMode = if groupAccessAvailable then "0750" else "0700";
          })
        ];

        unitConfig.RequiresMountsFor = "${cfg.dataDir}";
      };
  };
}
