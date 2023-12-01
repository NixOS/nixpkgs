{ config, lib, pkgs, ... }:

with lib;

let
  receiverSubmodule = {
    options = {
      postgresqlPackage = mkPackageOption pkgs "postgresql" {
        example = "postgresql_15";
      };

      directory = mkOption {
        type = types.path;
        example = literalExpression "/mnt/pg_wal/main/";
        description = lib.mdDoc ''
          Directory to write the output to.
        '';
      };

      statusInterval = mkOption {
        type = types.int;
        default = 10;
        description = lib.mdDoc ''
          Specifies the number of seconds between status packets sent back to the server.
          This allows for easier monitoring of the progress from server.
          A value of zero disables the periodic status updates completely,
          although an update will still be sent when requested by the server, to avoid timeout disconnect.
        '';
      };

      slot = mkOption {
        type = types.str;
        default = "";
        example = "some_slot_name";
        description = lib.mdDoc ''
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

      synchronous = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Flush the WAL data to disk immediately after it has been received.
          Also send a status packet back to the server immediately after flushing, regardless of {option}`statusInterval`.

          This option should be specified if the replication client of {command}`pg_receivewal` is configured on the server as a synchronous standby,
          to ensure that timely feedback is sent to the server.
        '';
      };

      compress = mkOption {
        type = types.ints.between 0 9;
        default = 0;
        description = lib.mdDoc ''
          Enables gzip compression of write-ahead logs, and specifies the compression level
          (`0` through `9`, `0` being no compression and `9` being best compression).
          The suffix `.gz` will automatically be added to all filenames.

          This option requires PostgreSQL >= 10.
        '';
      };

      connection = mkOption {
        type = types.str;
        example = "postgresql://user@somehost";
        description = lib.mdDoc ''
          Specifies parameters used to connect to the server, as a connection string.
          See [Section 34.1.1 of the PostgreSQL manual](https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING) for more information.

          Because {command}`pg_receivewal` doesn't connect to any particular database in the cluster,
          database name in the connection string will be ignored.
        '';
      };

      extraArgs = mkOption {
        type = with types; listOf str;
        default = [ ];
        example = literalExpression ''
          [
            "--no-sync"
          ]
        '';
        description = lib.mdDoc ''
          A list of extra arguments to pass to the {command}`pg_receivewal` command.
        '';
      };

      environment = mkOption {
        type = with types; attrsOf str;
        default = { };
        example = literalExpression ''
          {
            PGPASSFILE = "/private/passfile";
            PGSSLMODE = "require";
          }
        '';
        description = lib.mdDoc ''
          Environment variables passed to the service.
          Usable parameters are listed in [Section 34.14 of the PostgreSQL manual](https://www.postgresql.org/docs/current/libpq-envars.html).
        '';
      };
    };
  };

in {
  options = {
    services.postgresqlWalReceiver = {
      receivers = mkOption {
        type = with types; attrsOf (submodule receiverSubmodule);
        default = { };
        example = literalExpression ''
          {
            main = {
              postgresqlPackage = pkgs.postgresql_15;
              directory = /mnt/pg_wal/main/;
              slot = "main_wal_receiver";
              connection = "postgresql://user@somehost";
            };
          }
        '';
        description = lib.mdDoc ''
          PostgreSQL WAL receivers.
          Stream write-ahead logs from a PostgreSQL server using {command}`pg_receivewal` (formerly {command}`pg_receivexlog`).
          See [the man page](https://www.postgresql.org/docs/current/app-pgreceivewal.html) for more information.
        '';
      };
    };
  };

  config = let
    receivers = config.services.postgresqlWalReceiver.receivers;
  in mkIf (receivers != { }) {
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

    assertions = concatLists (attrsets.mapAttrsToList (name: config: [
      {
        assertion = config.compress > 0 -> versionAtLeast config.postgresqlPackage.version "10";
        message = "Invalid configuration for WAL receiver \"${name}\": compress requires PostgreSQL version >= 10.";
      }
    ]) receivers);

    systemd.tmpfiles.rules = mapAttrsToList (name: config: ''
      d ${escapeShellArg config.directory} 0750 postgres postgres - -
    '') receivers;

    systemd.services = with attrsets; mapAttrs' (name: config: nameValuePair "postgresql-wal-receiver-${name}" {
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

      script = let
        receiverCommand = postgresqlPackage:
         if (versionAtLeast postgresqlPackage.version "10")
           then "${postgresqlPackage}/bin/pg_receivewal"
           else "${postgresqlPackage}/bin/pg_receivexlog";
      in ''
        ${receiverCommand config.postgresqlPackage} \
          --no-password \
          --directory=${escapeShellArg config.directory} \
          --status-interval=${toString config.statusInterval} \
          --dbname=${escapeShellArg config.connection} \
          ${optionalString (config.compress > 0) "--compress=${toString config.compress}"} \
          ${optionalString (config.slot != "") "--slot=${escapeShellArg config.slot}"} \
          ${optionalString config.synchronous "--synchronous"} \
          ${concatStringsSep " " config.extraArgs}
      '';
    }) receivers;
  };

  meta.maintainers = with maintainers; [ pacien ];
}
