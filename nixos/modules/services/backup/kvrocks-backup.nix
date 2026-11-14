{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kvrocks;
in
{
  meta.maintainers = with lib.maintainers; [ xyenon ];

  options.services.kvrocks.backup = {
    enable = lib.mkEnableOption "Kvrocks backups";

    startAt = lib.mkOption {
      default = "*-*-* 01:15:00";
      type = with lib.types; either (listOf str) str;
      description = ''
        When to run the backup (see {manpage}`systemd.time(7)`).
        The default is 01:15 every day.
      '';
    };

    location = lib.mkOption {
      default = "/var/backup/kvrocks";
      type = lib.types.path;
      description = ''
        Root directory for Kvrocks backups. The `BGSAVE` checkpoint is written
        to {file}`checkpoint` and atomically promoted to {file}`current`.
        Restore by stopping kvrocks, replacing the database directory with
        {file}`current` in this location, and starting kvrocks again.
        See <https://kvrocks.apache.org/docs/backup>.
      '';
    };

    timeout = lib.mkOption {
      default = "10m";
      type = lib.types.str;
      example = "30m";
      description = ''
        How long to wait for `BGSAVE` to finish.
        Passed to {option}`systemd.services.kvrocks-backup.serviceConfig.TimeoutStartSec`.
      '';
    };

    redisPasswordFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      example = "/run/secrets/kvrocks-requirepass";
      description = ''
        File whose contents are used as `REDISCLI_AUTH` when talking to kvrocks.
        Needed if {option}`services.kvrocks.settings.requirepass` is set.
      '';
    };
  };

  config = lib.mkIf cfg.backup.enable {
    assertions = [
      {
        assertion = cfg.enable;
        message = "services.kvrocks.backup.enable requires services.kvrocks.enable.";
      }
    ];

    services.kvrocks.settings.backup-dir = "${cfg.backup.location}/checkpoint";

    systemd.tmpfiles.settings."10-kvrocks-backup"."${cfg.backup.location}".d = {
      user = cfg.user;
      group = cfg.group;
      mode = "0700";
    };

    systemd.services.kvrocks-backup = {
      description = "Backup of Kvrocks database";
      documentation = [
        "https://kvrocks.apache.org/docs/backup"
      ];
      requires = [ "kvrocks.service" ];
      after = [
        "kvrocks.service"
        "systemd-tmpfiles-setup.service"
        "systemd-tmpfiles-resetup.service"
      ];

      path = [
        pkgs.coreutils
        pkgs.gnugrep
      ];

      enableStrictShellChecks = true;

      script =
        let
          redisCli = lib.getExe' pkgs.redis "redis-cli";
          cliArgs =
            if cfg.settings.unixsocket != "" then
              [
                "-s"
                cfg.settings.unixsocket
              ]
            else
              [
                "-h"
                (builtins.head cfg.settings.bind)
                "-p"
                (toString cfg.settings.port)
              ];
          cli = lib.concatMapStringsSep " " lib.escapeShellArg ([ redisCli ] ++ cliArgs);

          checkpointDir = "${cfg.backup.location}/checkpoint";
          currentDir = "${cfg.backup.location}/current";
        in
        ''
          ${lib.optionalString (cfg.backup.redisPasswordFile != null) ''
            REDISCLI_AUTH="$(tr -d '\n' < ${lib.escapeShellArg cfg.backup.redisPasswordFile})"
            export REDISCLI_AUTH
          ''}

          info_field() {
            local value
            value="$( ${cli} INFO persistence | grep -m1 "^$1:" | cut -d: -f2- | tr -d '\r')"
            if [ -z "$value" ]; then
              echo "Missing INFO persistence field $1" >&2
              exit 1
            fi
            printf '%s\n' "$value"
          }

          if [ "$(info_field bgsave_in_progress)" = 1 ]; then
            echo "BGSAVE already in progress" >&2
            exit 1
          fi

          reply="$( ${cli} BGSAVE)"
          if [ "$reply" != OK ]; then
            echo "BGSAVE failed: $reply" >&2
            exit 1
          fi

          while [ "$(info_field bgsave_in_progress)" = 1 ]; do
            sleep 1
          done

          status="$(info_field last_bgsave_status)"
          if [ "$status" != ok ]; then
            echo "BGSAVE failed (status=$status)" >&2
            exit 1
          fi

          if [ ! -f ${lib.escapeShellArg checkpointDir}/CURRENT ]; then
            echo "Missing checkpoint ${checkpointDir}/CURRENT" >&2
            exit 1
          fi

          if [ -e ${lib.escapeShellArg currentDir} ]; then
            mv --exchange --no-target-directory ${lib.escapeShellArg checkpointDir} ${lib.escapeShellArg currentDir}
            rm -rf ${lib.escapeShellArg checkpointDir}
          else
            rm -rf ${lib.escapeShellArg currentDir}
            mv --no-target-directory ${lib.escapeShellArg checkpointDir} ${lib.escapeShellArg currentDir}
          fi

          echo "Backed up ${checkpointDir} to ${currentDir}"
        '';

      startAt = cfg.backup.startAt;

      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        TimeoutStartSec = cfg.backup.timeout;
        UMask = "0077";
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
        ReadWritePaths = [ cfg.backup.location ];
        ReadOnlyPaths = lib.optional (cfg.backup.redisPasswordFile != null) cfg.backup.redisPasswordFile;
      };
    };
  };
}
