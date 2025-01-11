{
  config,
  lib,
  pkgs,
  ...
}:

let
  tomlFormat = pkgs.formats.toml { };

  cfg = config.services.rustic;
  configFiles = lib.mapAttrs (k: v: tomlFormat.generate "rustic-${k}.toml" v) cfg.profiles;

  commonOpts =
    v:
    if v ? files then
      v.files
    else if v ? command then
      v.command
    else if v ? postgres then
      v.postgres
    else
      throw "unexpected: backup has none of the authorized types";

  backupType =
    v:
    if v ? files then
      "files"
    else if v ? command then
      "command"
    else if v ? postgres then
      "postgres"
    else
      throw "unexpected: backup has none of the authorized types";

  backupConfigToCmd =
    k: v:
    let
      o = commonOpts v;
      profileArgs = lib.concatMapStrings (s: " -P \"${s}\"") o.useProfiles;
      extraArgs = lib.concatMapStrings (s: " \"${s}\"") o.extraArgs;
      genericArgs = profileArgs + extraArgs;

      sourcesArgs = lib.concatMapStrings (s: " ${s}") v.files.sources;
      asPathArg = lib.optionalString (v.files.asPath != null) " --as-path \"${v.files.asPath}\"";
      ifFilesArgs = lib.optionalString (v ? files) (sourcesArgs + asPathArg);

      commandArg = " --stdin-command \"${v.command.command}\" -"; # stdin-command requires adding `-` as a source
      stdinFilenameArg = lib.optionalString (
        v.command.filename != null
      ) " --stdin-filename \"${v.command.filename}\"";
      ifCommandArgs = lib.optionalString (v ? command) (commandArg + stdinFilenameArg);

      pipeJsonIntoCmd =
        if o.pipeJsonInto ? nothing then
          ""
        else if o.pipeJsonInto ? command then
          " --json | ${o.pipeJsonInto.command} \"$1\""
        else if o.pipeJsonInto ? prometheus then
          " --json | ${prometheusWriteScript o.pipeJsonInto.prometheus.nodeExporterCollectorFolder} \"$1\""
        else
          throw "unexpected: pipeJsonInto has none of the authorized types";
    in
    if v ? postgres then
      let
        systemctl = "${config.systemd.package}/bin/systemctl";
      in
      pkgs.writeScript "rustic-postgres-starter-${k}" ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        ${systemctl} start --no-block rustic-postgres-globals-${k}.service

        ${pkgs.sudo}/bin/sudo -u postgres \
          ${config.services.postgresql.package}/bin/psql \
          -c 'SELECT datname FROM pg_database' \
          --csv \
          | tail -n +2 \
          | grep -Ev '^template0$' \
          | xargs -I {} \
          ${systemctl} start --no-block rustic-postgres-db-${k}@{}.service
      ''
    else
      pkgs.writeScript "rustic-backup-${k}" ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        TZ="" ${cfg.package}/bin/rustic backup${ifFilesArgs + ifCommandArgs + genericArgs + pipeJsonIntoCmd}
      '';

  prometheusNumericMetrics = [
    "files_new"
    "files_changed"
    "files_unmodified"
    "total_files_processed"
    "total_bytes_processed"
    "dirs_new"
    "dirs_changed"
    "dirs_unmodified"
    "total_dirs_processed"
    "total_dirsize_processed"
    "data_blobs"
    "tree_blobs"
    "data_added"
    "data_added_packed"
    "data_added_files"
    "data_added_files_packed"
    "data_added_trees"
    "data_added_trees_packed"
    "backup_duration"
    "total_duration"
  ];

  prometheusTimeMetrics = [
    "backup_start"
    "backup_end"
  ];

  prometheusAllMetrics = prometheusNumericMetrics ++ prometheusTimeMetrics;

  prometheusJqTemplate = lib.concatMapStrings (m: ''
    rustic_backup_${m}{id=\"{{id}}\"} {{${m}}}
  '') prometheusAllMetrics;

  prometheusWriteScript =
    f:
    pkgs.writeScript "rustic-write-to-prometheus" ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      ${pkgs.jq}/bin/jq -r --arg template "${prometheusJqTemplate}" '
        . as $json
        | $template
        | gsub("{{id}}"; "'"$1"'")
        ${lib.concatMapStrings (
          m: ''| gsub("{{${m}}}"; $json.summary.${m} | tostring)''
        ) prometheusNumericMetrics}
        ${lib.concatMapStrings
          # jq's `fromdate` builtins do not support sub-second accuracy (as of early 2025)
          (
            m:
            ''| gsub("{{${m}}}"; $json.summary.${m} | sub(".[0-9]{0,9}Z"; "Z") | fromdateiso8601 | tostring)''
          )
          prometheusTimeMetrics
        }
      ' > "${f}/rustic-backup-$1.prom.next"
      mv "${f}/rustic-backup-$1.prom.next" "${f}/rustic-backup-$1.prom"
    '';

  commonOptions = {
    startAt = lib.mkOption {
      type = with lib.types; either (listOf str) str;
      description = ''
        Time(s) at which to run this operation.

        The format is documented in `man systemd.time`.
      '';
    };

    useProfiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Config profiles to use";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra command-line arguments to pass to the `rustic` call.";
    };
  };

  commonBackupOptions = commonOptions // {
    pipeJsonInto = lib.mkOption {
      description = "Command that will be called on the JSON result of `rustic backup`.";
      default = {
        nothing = { };
      };
      type = lib.types.attrTag {
        nothing = lib.mkOption {
          description = "Do nothing with the result.";
          type = lib.types.unspecified;
        };

        command = lib.mkOption {
          description = ''
            Run a command on the result.

            It will be called with the JSON result on standard input, and an identifier of
            the backup section as an argument. You can pass any other arguments eg. as tags,
            which rustic will return in its JSON output.
          '';
          type = lib.types.str;
        };

        prometheus = lib.mkOption {
          description = "Write the result as prometheus metrics.";
          type = lib.types.submodule {
            options.nodeExporterCollectorFolder = lib.mkOption {
              type = lib.types.path;
              description = ''
                Folder that is exported by the node exporter, and in which the metrics should be placed.

                This should be configured in the node exporter as `--collector.textfile.directory=`.
              '';
            };
          };
        };
      };
    };
  };
in
{
  options.services.rustic = {
    enable = lib.mkEnableOption "rustic";
    package = lib.mkPackageOption pkgs "rustic" { };

    checkProfiles = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        If enabled, checks that the generated rustic profiles are valid.

        Note that imports that cannot be resolved are accepted. This allows
        the recommended setup of using an imported file that only root can read
        to store the passwords.
      '';
    };

    profiles = lib.mkOption {
      type = lib.types.attrsOf tomlFormat.type;
      default = { };
      description = ''
        Configuration files for rustic, see
        <https://github.com/rustic-rs/rustic/blob/main/config/README.md>
        for supported settings.

        The `rustic` profile will be the one used by default.

        Note that this will be world-readable in the nix store, so do not put
        your passwords here! Instead, you should write them somewhere safe, and
        then set, eg. if you put it in `/root/rustic-passwords.toml`:
        ```nix
        global.use-profiles = ["/root/rustic-passwords"];
        ```
      '';
    };

    backups = lib.mkOption {
      default = { };
      description = ''
        Backup configurations.

        Each key is the name of the backup, and the value is the parameters
        with which this backup will be run. This allows setting multiple backups
        running at different intervals, and backing up different folders or
        databases.
      '';
      type = lib.types.attrsOf (
        lib.types.attrTag {
          files = lib.mkOption {
            description = "Backup files and directories.";
            type = lib.types.submodule {
              options = commonBackupOptions // {
                sources = lib.mkOption {
                  type = lib.types.listOf lib.types.path;
                  default = [ ];
                  description = ''
                    List of sources to backup.

                    Defaults to the ones defined in the relevant configuration files.
                  '';
                };

                asPath = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Manually set the backup path in snapshot";
                };
              };
            };
          };

          command = lib.mkOption {
            description = "Backup the output of a command.";
            type = lib.types.submodule {
              options = commonBackupOptions // {
                command = lib.mkOption {
                  type = lib.types.str;
                  description = "Command of which to backup the output";
                };

                filename = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = ''
                    Filename to use in the backup.

                    Defaults to the profile-provided filename, or `stdin`.
                  '';
                };
              };
            };
          };

          postgres = lib.mkOption {
            description = ''
              Backup all postgresql databases.

              Use a custom `command` using `pg_dump` if you want to backup a single
              database.

              This backs up globals and individual databases in independent files.
            '';
            type = lib.types.submodule {
              options = commonBackupOptions // {
                prefix = lib.mkOption {
                  type = lib.types.str;
                  default = "/postgres";
                  description = "Path prefix for the dumps.";
                };
              };
            };
          };
        }
      );
    };

    checks = lib.mkOption {
      default = { };
      description = ''
        Check configurations.

        Each key is the name of the check, and the value is the parameters
        with which this check will be run. This allows setting multiple check
        running at different intervals, eg. a frequent metadata-only check and
        an infrequent full-data check.
      '';
      type = lib.types.attrsOf (lib.types.submodule { options = commonOptions; });
    };

    prune = commonOptions // {
      enable = lib.mkEnableOption "rustic-prune";
    };
  };

  config = lib.mkIf cfg.enable {
    system.checks = lib.optional cfg.checkProfiles (
      pkgs.runCommand "rustic-profiles-check" { } ''
        ${lib.concatMapStrings (p: ''
          ln -s ${p} ./rustic-config-for-checking.toml
          ${cfg.package}/bin/rustic show-config -P rustic-config-for-checking > /dev/null
          rm ./rustic-config-for-checking.toml
        '') (lib.attrValues configFiles)}
        touch $out
      ''
    );

    environment.systemPackages = [ cfg.package ];

    environment.etc = lib.mapAttrs' (k: v: {
      name = "rustic/${k}.toml";
      value.source = v;
    }) configFiles;

    systemd.services =
      lib.concatMapAttrs (
        k: v:
        {
          "rustic-backup-${k}" = {
            serviceConfig = {
              Type = "oneshot";
              User = "root";
              ExecStart = "${backupConfigToCmd k v} ${backupType v}-${k}";
            };
            startAt = (commonOpts v).startAt;
          };
        }
        // lib.optionalAttrs (v ? postgres) {
          "rustic-postgres-globals-${k}" = {
            serviceConfig = {
              Type = "oneshot";
              User = "root";
              ExecStart = "${
                backupConfigToCmd k {
                  command = v.postgres // {
                    filename = "${v.postgres.prefix}/globals.sql";
                    command = "${pkgs.sudo}/bin/sudo -u postgres ${config.services.postgresql.package}/bin/pg_dumpall --globals-only";
                  };
                }
              } postgres-globals-${k}";
            };
          };

          "rustic-postgres-db-${k}@" = {
            serviceConfig = {
              Type = "oneshot";
              User = "root";
              ExecStart = "${
                backupConfigToCmd k {
                  command = v.postgres // {
                    filename = "$3";
                    command = "${pkgs.sudo}/bin/sudo -u postgres ${config.services.postgresql.package}/bin/pg_dump $2";
                  };
                }
              } 'postgres-db-${k}-%i' '%i' '${v.postgres.prefix}/db/%i.sql'";
            };
          };
        }
      ) cfg.backups
      // lib.concatMapAttrs (
        k: v:
        let
          profiles = lib.concatMapStrings (p: " -P \"${p}\"") v.useProfiles;
          extraArgs = lib.concatMapStrings (a: " \"${a}\"") v.extraArgs;
        in
        {
          "rustic-check-${k}" = {
            serviceConfig = {
              Type = "oneshot";
              User = "root";
              ExecStart = "${cfg.package}/bin/rustic check${profiles}${extraArgs}";
            };
            startAt = v.startAt;
          };
        }
      ) cfg.checks
      // lib.optionalAttrs cfg.prune.enable (
        let
          profiles = lib.concatMapStrings (p: " -P \"${p}\"") cfg.prune.useProfiles;
          extraArgs = lib.concatMapStrings (a: " \"${a}\"") cfg.prune.extraArgs;
        in
        {
          "rustic-prune" = {
            serviceConfig = {
              Type = "oneshot";
              User = "root";
              ExecStart = "${cfg.package}/bin/rustic forget --prune${profiles}${extraArgs}";
            };
            startAt = cfg.prune.startAt;
          };
        }
      );
  };
}
