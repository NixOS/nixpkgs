{
  config,
  lib,
  pkgs,
  ...
}:
let
  receiverSubmodule = {
    options = {
      postgresqlPackage = lib.mkPackageOption pkgs "postgresql" {
        example = "postgresql_15";
      };

      directory = lib.mkOption {
        type = lib.types.path;
        example = lib.literalExpression "/mnt/pg_wal/main/";
        description = ''
          Directory to write the output to.
        '';
      };

      statusInterval = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = ''
          Specifies the number of seconds between status packets sent back to the server.
          This allows for easier monitoring of the progress from server.
          A value of zero disables the periodic status updates completely,
          although an update will still be sent when requested by the server, to avoid timeout disconnect.
        '';
      };

      slot = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "some_slot_name";
        description = ''
          Require {command}`pg_receivewal` to use an existing replication slot (see
          [Section 26.2.6 of the PostgreSQL manual](https://www.postgresql.org/docs/current/warm-standby.html#STREAMING-REPLICATION-SLOTS)).
          When this option is used, {command}`pg_receivewal` will report a flush position to the server,
          indicating when each segment has been synchronized to disk so that the server can remove that segment if it is not otherwise needed.

          When the replication client of {command}`pg_receivewal` is configured on the server as a synchronous standby,
          then using a replication slot will report the flush position to the server, but only when a WAL file is closed.
          Therefore, that configuration will cause transactions on the primary to wait for a long time and effectively not work satisfactorily.
          The option {option}`synchronous` must be specified in addition to make this work correctly.
        '';
      };

      synchronous = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Flush the WAL data to disk immediately after it has been received.
          Also send a status packet back to the server immediately after flushing, regardless of {option}`statusInterval`.

          This option should be specified if the replication client of {command}`pg_receivewal` is configured on the server as a synchronous standby,
          to ensure that timely feedback is sent to the server.
        '';
      };

      compress = lib.mkOption {
        type = lib.types.ints.between 0 9;
        default = 0;
        description = ''
          Enables gzip compression of write-ahead logs, and specifies the compression level
          (`0` through `9`, `0` being no compression and `9` being best compression).
          The suffix `.gz` will automatically be added to all filenames.

          This option requires PostgreSQL >= 10.
        '';
      };

      connection = lib.mkOption {
        type = lib.types.str;
        example = "postgresql://user@somehost";
        description = ''
          Specifies parameters used to connect to the server, as a connection string.
          See [Section 34.1.1 of the PostgreSQL manual](https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING) for more information.

          Because {command}`pg_receivewal` doesn't connect to any particular database in the cluster,
          database name in the connection string will be ignored.
        '';
      };

      extraArgs = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        example = lib.literalExpression ''
          [
            "--no-sync"
          ]
        '';
        description = ''
          A list of extra arguments to pass to the {command}`pg_receivewal` command.
        '';
      };

      environment = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        example = lib.literalExpression ''
          {
            PGPASSFILE = "/private/passfile";
            PGSSLMODE = "require";
          }
        '';
        description = ''
          Environment variables passed to the service.
          Usable parameters are listed in [Section 34.14 of the PostgreSQL manual](https://www.postgresql.org/docs/current/libpq-envars.html).
        '';
      };
    };
  };

in
{
  options = {
    services.postgresqlWalReceiver = {
      receivers = lib.mkOption {
        type = with lib.types; attrsOf (submodule receiverSubmodule);
        default = { };
        example = lib.literalExpression ''
          {
            main = {
              postgresqlPackage = pkgs.postgresql_15;
              directory = /mnt/pg_wal/main/;
              slot = "main_wal_receiver";
              connection = "postgresql://user@somehost";
            };
          }
        '';
        description = ''
          PostgreSQL WAL receivers.
          Stream write-ahead logs from a PostgreSQL server using {command}`pg_receivewal` (formerly {command}`pg_receivexlog`).
          See [the man page](https://www.postgresql.org/docs/current/app-pgreceivewal.html) for more information.
        '';
      };
    };
  };

  config =
    let
      receivers = config.services.postgresqlWalReceiver.receivers;
    in
    lib.mkIf (receivers != { }) {
      users = {
        users.postgres = {
          uid = config.ids.uids.postgres;
          group = "postgres";
          description = "PostgreSQL server user";
        };

        groups.postgres = {
          gid = config.ids.gids.postgres;
        };
      };

      assertions = lib.concatLists (
        lib.attrsets.mapAttrsToList (name: config: [
          {
            assertion = config.compress > 0 -> lib.versionAtLeast config.postgresqlPackage.version "10";
            message = "Invalid configuration for WAL receiver \"${name}\": compress requires PostgreSQL version >= 10.";
          }
        ]) receivers
      );

      systemd.tmpfiles.rules = lib.mapAttrsToList (name: config: ''
        d ${lib.escapeShellArg config.directory} 0750 postgres postgres - -
      '') receivers;

      systemd.services = lib.mapAttrs' (
        name: config:
        lib.nameValuePair "postgresql-wal-receiver-${name}" {
          description = "PostgreSQL WAL receiver (${name})";
          wantedBy = [ "multi-user.target" ];
          startLimitIntervalSec = 0; # retry forever, useful in case of network disruption

          serviceConfig = {
            User = "postgres";
            Group = "postgres";
            KillSignal = "SIGINT";
            Restart = "always";
            RestartSec = 60;
          };

          inherit (config) environment;

          script =
            let
              receiverCommand =
                postgresqlPackage:
                if (lib.versionAtLeast postgresqlPackage.version "10") then
                  "${postgresqlPackage}/bin/pg_receivewal"
                else
                  "${postgresqlPackage}/bin/pg_receivexlog";
            in
            ''
              ${receiverCommand config.postgresqlPackage} \
                --no-password \
                --directory=${lib.escapeShellArg config.directory} \
                --status-interval=${toString config.statusInterval} \
                --dbname=${lib.escapeShellArg config.connection} \
                ${lib.optionalString (config.compress > 0) "--compress=${toString config.compress}"} \
                ${lib.optionalString (config.slot != "") "--slot=${lib.escapeShellArg config.slot}"} \
                ${lib.optionalString config.synchronous "--synchronous"} \
                ${lib.concatStringsSep " " config.extraArgs}
            '';
        }
      ) receivers;
    };

  meta.maintainers = with lib.maintainers; [ euxane ];
}
