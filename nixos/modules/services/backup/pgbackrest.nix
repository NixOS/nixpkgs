{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.pgbackrest;

  settingsFormat = pkgs.formats.ini {
    listsAsDuplicateKeys = true;
  };

  # pgBackRest "options"
  settingsType =
    with lib.types;
    attrsOf (oneOf [
      bool
      ints.unsigned
      str
      (attrsOf str)
      (listOf str)
    ]);

  # Applied to both repoNNN-* and pgNNN-* options in global and stanza sections.
  flattenWithIndex =
    attrs: prefix:
    lib.concatMapAttrs (
      name:
      let
        index = lib.lists.findFirstIndex (n: n == name) null (lib.attrNames attrs);
        index1 = index + 1;
      in
      lib.mapAttrs' (option: lib.nameValuePair "${prefix}${toString index1}-${option}")
    ) attrs;

  # Remove nulls, turn attrsets into lists and bools into y/n
  normalize =
    x:
    lib.pipe x [
      (lib.filterAttrs (_: v: v != null))
      (lib.mapAttrs (_: v: if lib.isAttrs v then lib.mapAttrsToList (n': v': "${n'}=${v'}") v else v))
      (lib.mapAttrs (
        _: v:
        if v == true then
          "y"
        else if v == false then
          "n"
        else
          v
      ))
    ];

  fullConfig = {
    global = normalize (cfg.settings // flattenWithIndex cfg.repos "repo");
  }
  // lib.mapAttrs' (
    cmd: settings: lib.nameValuePair "global:${cmd}" (normalize settings)
  ) cfg.commands
  // lib.mapAttrs (
    _: cfg': normalize (cfg'.settings // flattenWithIndex cfg'.instances "pg")
  ) cfg.stanzas;

  namedJobs = lib.listToAttrs (
    lib.flatten (
      lib.mapAttrsToList (
        stanza:
        { jobs, ... }:
        lib.mapAttrsToList (
          job: attrs: lib.nameValuePair "pgbackrest-${stanza}-${job}" (attrs // { inherit stanza job; })
        ) jobs
      ) cfg.stanzas
    )
  );

  disabledOption = lib.mkOption {
    default = null;
    readOnly = true;
    internal = true;
  };

  secretPathOption =
    with lib.types;
    lib.mkOption {
      type = nullOr externalPath;
      default = null;
      internal = true;
    };
in

{
  meta = {
    maintainers = with lib.maintainers; [ wolfgangwalther ];
  };

  # TODO: Add enableServer option and corresponding pgBackRest TLS server service.
  # TODO: Write wrapper around pgbackrest to turn --repo=<name> into --repo=<number>
  # The following two are dependent on improvements upstream:
  #   https://github.com/pgbackrest/pgbackrest/issues/2621
  # TODO: Add support for more repository types
  # TODO: Support passing encryption key safely
  options.services.pgbackrest = {
    enable = lib.mkEnableOption "pgBackRest";

    repos = lib.mkOption {
      type =
        with lib.types;
        attrsOf (
          submodule (
            { config, name, ... }:
            let
              setHostForType =
                type:
                if name == "localhost" then
                  null
                # "posix" is the default repo type, which uses the -host option.
                # Other types use prefixed options, for example -sftp-host.
                else if config.type or "posix" != type then
                  null
                else
                  name;
            in
            {
              freeformType = settingsType;

              options.host = lib.mkOption {
                type = nullOr str;
                default = setHostForType "posix";
                defaultText = lib.literalExpression "name";
                description = "Repository host when operating remotely";
              };

              options.sftp-host = lib.mkOption {
                type = nullOr str;
                default = setHostForType "sftp";
                defaultText = lib.literalExpression "name";
                description = "SFTP repository host";
              };

              options.sftp-private-key-file = lib.mkOption {
                type = nullOr externalPath;
                default = null;
                description = ''
                  SFTP private key file.

                  The file must be accessible by both the pgbackrest and the postgres users.
                '';
              };

              # The following options should not be used; they would store secrets in the store.
              options.azure-key = disabledOption;
              options.cipher-pass = disabledOption;
              options.s3-key = disabledOption;
              options.s3-key-secret = disabledOption;
              options.s3-kms-key-id = disabledOption; # unsure whether that's a secret or not
              options.s3-sse-customer-key = disabledOption; # unsure whether that's a secret or not
              options.s3-token = disabledOption;
              options.sftp-private-key-passphrase = disabledOption;

              # The following options are not fully supported / tested, yet, but point to files with secrets.
              # Users can already set those options, but we'll force non-store paths.
              options.gcs-key = secretPathOption;
              options.host-cert-file = secretPathOption;
              options.host-key-file = secretPathOption;
            }
          )
        );
      default = { };
      description = ''
        An attribute set of repositories as described in:
        <https://pgbackrest.org/configuration.html#section-repository>

        Each repository defaults to set `repo-host` to the attribute's name.
        The special value "localhost" will unset `repo-host`.

        ::: {.note}
        The prefix `repoNNN-` is added automatically.
        Example: Use `path` instead of `repo1-path`.
        :::
      '';
      example = lib.literalExpression ''
        {
          localhost.path = "/var/lib/backup";
          "backup.example.com".host-type = "tls";
        }
      '';
    };

    stanzas = lib.mkOption {
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            jobs = lib.mkOption {
              type = lib.types.attrsOf (
                lib.types.submodule {
                  options.schedule = lib.mkOption {
                    type = lib.types.str;
                    description = ''
                      When or how often the backup should run.
                      Must be in the format described in {manpage}`systemd.time(7)`.
                    '';
                  };

                  options.type = lib.mkOption {
                    type = lib.types.str;
                    description = ''
                      Backup type as described in:
                      <https://pgbackrest.org/command.html#command-backup/category-command/option-type>
                    '';
                  };
                }
              );
              default = { };
              description = ''
                Backups jobs to schedule for this stanza as described in:
                <https://pgbackrest.org/user-guide.html#quickstart/schedule-backup>
              '';
              example = lib.literalExpression ''
                {
                  weekly = { schedule = "Sun, 6:30"; type = "full"; };
                  daily = { schedule = "Mon..Sat, 6:30"; type = "diff"; };
                }
              '';
            };

            instances = lib.mkOption {
              type =
                with lib.types;
                attrsOf (
                  submodule (
                    { name, ... }:
                    {
                      freeformType = settingsType;
                      options.host = lib.mkOption {
                        type = nullOr str;
                        default = if name == "localhost" then null else name;
                        defaultText = lib.literalExpression ''if name == "localhost" then null else name'';
                        description = "PostgreSQL host for operating remotely.";
                      };

                      # The following options are not fully supported / tested, yet, but point to files with secrets.
                      # Users can already set those options, but we'll force non-store paths.
                      options.host-cert-file = secretPathOption;
                      options.host-key-file = secretPathOption;
                    }
                  )
                );
              default = { };
              description = ''
                An attribute set of database instances as described in:
                <https://pgbackrest.org/configuration.html#section-stanza>

                Each instance defaults to set `pg-host` to the attribute's name.
                The special value "localhost" will unset `pg-host`.

                ::: {.note}
                The prefix `pgNNN-` is added automatically.
                Example: Use `user` instead of `pg1-user`.
                :::
              '';
              example = lib.literalExpression ''
                {
                  localhost.database = "app";
                  "postgres.example.com".port = "5433";
                }
              '';
            };

            settings = lib.mkOption {
              type = lib.types.submodule {
                freeformType = settingsType;

                # The following options are not fully supported / tested, yet, but point to files with secrets.
                # Users can already set those options, but we'll force non-store paths.
                options.tls-server-cert-file = secretPathOption;
                options.tls-server-key-file = secretPathOption;
              };
              default = { };
              description = ''
                An attribute set of options as described in:
                <https://pgbackrest.org/configuration.html>

                All options can be used.
                Repository options should be set via [`repos`](#opt-services.pgbackrest.repos) instead.
                Stanza options should be set via [`instances`](#opt-services.pgbackrest.stanzas._name_.instances) instead.
              '';
              example = lib.literalExpression ''
                {
                  process-max = 2;
                }
              '';
            };
          };
        });
      default = { };
      description = ''
        An attribute set of stanzas as described in:
        <https://pgbackrest.org/user-guide.html#quickstart/configure-stanza>
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsType;

        # The following options are not fully supported / tested, yet, but point to files with secrets.
        # Users can already set those options, but we'll force non-store paths.
        options.tls-server-cert-file = secretPathOption;
        options.tls-server-key-file = secretPathOption;
      };
      default = { };
      description = ''
        An attribute set of options as described in:
        <https://pgbackrest.org/configuration.html>

        All globally available options, i.e. all except stanza options, can be used.
        Repository options should be set via [`repos`](#opt-services.pgbackrest.repos) instead.
      '';
      example = lib.literalExpression ''
        {
          process-max = 2;
        }
      '';
    };

    commands =
      lib.genAttrs
        [
          # List of commands from https://pgbackrest.org/command.html:
          "annotate"
          "archive-get"
          "archive-push"
          "backup"
          "check"
          "expire"
          "help"
          "info"
          "repo-get"
          "repo-ls"
          "restore"
          "server"
          "server-ping"
          "stanza-create"
          "stanza-delete"
          "stanza-upgrade"
          "start"
          "stop"
          "verify"
          "version"
        ]
        (
          command:
          lib.mkOption {
            type = lib.types.submodule {
              freeformType = settingsType;

              # The following options are not fully supported / tested, yet, but point to files with secrets.
              # Users can already set those options, but we'll force non-store paths.
              options.tls-server-cert-file = secretPathOption;
              options.tls-server-key-file = secretPathOption;
            };
            default = { };
            description = ''
              Options for the '${command}' command.

              An attribute set of options as described in:
              <https://pgbackrest.org/configuration.html>

              All globally available options, i.e. all except stanza options, can be used.
              Repository options should be set via [`repos`](#opt-services.pgbackrest.repos) instead.
            '';
          }
        );
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.pgbackrest.settings = {
          log-level-console = lib.mkDefault "info";
          log-level-file = lib.mkDefault "off";
          cmd-ssh = lib.getExe pkgs.openssh;
        };

        environment.systemPackages = [ pkgs.pgbackrest ];
        environment.etc."pgbackrest/pgbackrest.conf".source =
          settingsFormat.generate "pgbackrest.conf" fullConfig;

        users.users.pgbackrest = {
          name = "pgbackrest";
          group = "pgbackrest";
          description = "pgBackRest service user";
          isSystemUser = true;
          useDefaultShell = true;
          createHome = true;
          home = cfg.repos.localhost.path or "/var/lib/pgbackrest";
        };
        users.groups.pgbackrest = { };

        systemd.services = lib.mapAttrs (
          _:
          {
            stanza,
            job,
            type,
            ...
          }:
          {
            description = "pgBackRest job ${job} for stanza ${stanza}";

            serviceConfig = {
              User = "pgbackrest";
              Group = "pgbackrest";
              Type = "oneshot";
              # stanza-create is idempotent, so safe to always run
              ExecStartPre = "${lib.getExe pkgs.pgbackrest} --stanza='${stanza}' stanza-create";
              ExecStart = "${lib.getExe pkgs.pgbackrest} --stanza='${stanza}' backup --type='${type}'";
            };
          }
        ) namedJobs;

        systemd.timers = lib.mapAttrs (
          name:
          {
            stanza,
            job,
            schedule,
            ...
          }:
          {
            description = "pgBackRest job ${job} for stanza ${stanza}";
            wantedBy = [ "timers.target" ];
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            timerConfig = {
              OnCalendar = schedule;
              Persistent = true;
              Unit = "${name}.service";
            };
          }
        ) namedJobs;
      }

      # The default stanza is set up for the local postgresql instance.
      # It does not backup automatically, the systemd timer still needs to be set.
      (lib.mkIf config.services.postgresql.enable {
        services.pgbackrest.stanzas.default = {
          settings.cmd = lib.getExe pkgs.pgbackrest;
          instances.localhost = {
            path = config.services.postgresql.dataDir;
            user = "postgres";
          };
        };
        # If PostgreSQL runs on the same machine, any restore will have to be done with that user.
        # Keeping the lock file in a directory writeable by the postgres user prevents errors.
        services.pgbackrest.commands.restore.lock-path = "/tmp/postgresql";
        services.postgresql.identMap = ''
          postgres pgbackrest postgres
        '';
        services.postgresql.initdbArgs = [ "--allow-group-access" ];
        users.users.pgbackrest.extraGroups = [ "postgres" ];

        services.postgresql.settings = {
          archive_command = ''${lib.getExe pkgs.pgbackrest} --stanza=default archive-push "%p"'';
          archive_mode = lib.mkDefault "on";
        };
        users.groups.pgbackrest.members = [ "postgres" ];
      })
    ]
  );
}
