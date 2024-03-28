{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    allUnique
    attrNames
    concatLists
    concatMap
    concatMapAttrs
    concatMapStringsSep
    elem
    escapeShellArg
    getExe
    hasAttr
    hasPrefix
    literalExpression
    mapAttrs
    mapAttrs'
    mapAttrsToList
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    nameValuePair
    optional
    optionalAttrs
    ;

  inherit (lib.lists) map;

  inherit (lib.types)
    attrsOf
    bool
    either
    enum
    lines
    listOf
    nullOr
    passwdEntry
    path
    str
    submodule
    ;

  inherit (utils) escapeSystemdExecArgs;

  mkJobTarget = name: _: {
    name = "bupstash-${name}";
    value = {
      description = "Bupstash group job for ${name}.";
      unitConfig = {
        StopWhenUnneeded = true;
      };
    };
  };

  mkJobTimer = name: job: {
    name = "bupstash-${name}";
    value = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "bupstash-${name}.target";
        OnCalendar = job.startAt;
      };
    };
  };

  mkJobUnits =
    name: job:
    {
      "bupstash-${name}-prehook" = mkIf (job.preHook != "") {
        description = "Hook that runs before the ${name} bupstash backup.";

        partOf = [ "bupstash-${name}.target" ];
        wantedBy = [ "bupstash-${name}.target" ];

        script = job.preHook;

        serviceConfig = {
          # Prevents the unit to run multiple times before the postHook has finished
          RemainAfterExit = true;
          StateDirectory = "bupstash";
          Type = "oneshot";
          WorkingDirectory = "/var/lib/bupstash";
        };
      };

      "bupstash-${name}-posthook" = mkIf (job.postHook != "" || job.preHook != "") {
        description = "Hook that runs after the ${name} bupstash backup.";

        partOf = [ "bupstash-${name}.target" ];
        wantedBy = [ "bupstash-${name}.target" ];

        # Require the preHook Unit, so that in case of failure it does not try to run
        requires = optional (job.preHook != "") "bupstash-${name}-prehook.service";

        script = job.postHook;

        serviceConfig =
          # Default configuration, used in all cases
          {
            StateDirectory = "bupstash";
            Type = "oneshot";
            WorkingDirectory = "/var/lib/bupstash";
          }
          # When postHook is empty, then this unit only exists to stop the prehook
          // (optionalAttrs (job.postHook == "") {
            ExecStart = "systemctl stop bupstash-${name}-prehook.service";
            # Stopping the prehook returns the SIGTERM value, interpret it as a success
            SuccessExitStatus = [ "SIGTERM" ];
          })
          # When both postHook and preHook exist, we need to stop the prehook after running the posthook
          // (optionalAttrs (job.preHook != "" && job.postHook != "") {
            ExecStopPost = "systemctl stop bupstash-${name}-prehook";
          });
      };
    }
    // (mapAttrs' (
      repo-name: repo:
      let
        preHookService = optional (job.preHook != "") "bupstash-${name}-prehook.service";
        postHookService = optional (
          job.postHook != "" || job.preHook != ""
        ) "bupstash-${name}-posthook.service";
      in
      nameValuePair "bupstash-${name}-${repo-name}" {
        description = ''
          Job for the ${name} bupstash backup, using ${repo.desc}.
        '';

        documentation = [
          "man:bupstash-put(1)"
          "https://bupstash.io/doc/man/bupstash-put.html"
        ];

        path = [ pkgs.openssh ];

        after = preHookService;
        before = postHookService;

        wants = preHookService ++ postHookService;

        partOf = [ "bupstash-${name}.target" ];
        wantedBy = [ "bupstash-${name}.target" ];

        preStart = mkIf repo.createRepository ''
          # We assume that a repository is already initialized iff the sentinel file exists
          if [ ! -f ".initialized" ]; then
            ${bupstash} init && touch .initialized
          fi
        '';

        environment =
          {
            BUPSTASH_SEND_LOG = "/var/cache/bupstash/${name}.${repo-name}/sendlog";
          }
          // (
            if (job.keyCommand != null) then
              { BUPSTASH_KEY_COMMAND = job.keyCommand; }
            else
              { BUPSTASH_KEY = job.key; }
          )
          // repo.env;

        serviceConfig = {
          AmbientCapabilities = [ "CAP_DAC_READ_SEARCH" ];
          CacheDirectory = "bupstash/${name}.${repo-name}";
          DynamicUser = true;
          ExecStart = escapeSystemdExecArgs (
            [
              bupstash
              "put"
            ]
            ++ optional (job.command != null) "--exec"
            ++ job.extraArgs
            ++ (concatMap (p: [
              "--exclude"
              p
            ]) job.excludes)
            # https://github.com/andrewchambers/bupstash/issues/389
            ++ (mapAttrsToList (key: value: "${key}=${value}") job.tags)
            ++ [ "::" ]
            ++ (if (job.command == null) then job.paths else job.command)
          );
          Group = mkIf (job.group != null) job.group;
          StateDirectory = "bupstash/${name}.${repo-name}";
          Type = "oneshot";
          User = job.user;
          WorkingDirectory = "/var/lib/bupstash/${name}.${repo-name}";
        };
      }
    ) (mkRepositories job));

  mkRepositories =
    job:
    (mapAttrs (name: repo: {
      env.BUPSTASH_REPOSITORY = repo;
      createRepository = elem name job.createRepositories;
      desc = "the repository '${repo}'";
    }) job.repositories)
    // (mapAttrs (name: cmd: {
      env.BUPSTASH_REPOSITORY_COMMAND = cmd;
      createRepository = elem name job.createRepositories;
      desc = "the command '${cmd}'";
    }) job.repositoryCommands);

  mkAuthorizedKeys =
    {
      repo,
      keys,
      allowed,
    }:
    if cfg.repositories.restrictCommands then
      map (
        key:
        ''command="${bupstash} serve ${
          concatMapStringsSep " " (a: "--allow-${a}") allowed
        } ${escapeShellArg "${cfg.repositories.home}/${repo}"}",restrict ${key}''
      ) keys
    else
      keys;

  cfg = config.services.bupstash;

  bupstash = getExe cfg.package;

  defaultClientUser = "bupstash";
  defaultRepositoryUser = "bupstash-repo";
in
{
  meta.maintainers = [ lib.maintainers.thubrecht ];

  options.services.bupstash = {
    package = mkPackageOption pkgs "bupstash" { };

    repositories = {
      enable = mkEnableOption "bupstash repositories that can be accessed through ssh.";

      user = mkOption {
        type = str;
        default = defaultRepositoryUser;
        description = "User used for connection to the bupstash repository.";
      };

      group = mkOption {
        type = str;
        default = defaultRepositoryUser;
        description = "Group of the user used for connection to the bupstash repository.";
      };

      access = mkOption {
        type = listOf (submodule {
          options = {
            repo = mkOption {
              type = str;
              description = "Name of the repository.";
            };

            keys = mkOption {
              type = listOf str;
              default = [ ];
              description = "List of ssh keys that can be used to access this repository.";
            };

            allowed = mkOption {
              type = listOf (enum [
                "init"
                "put"
                "list"
                "get"
                "remove"
                "gc"
                "sync"
              ]);
              default = [ ];
              description = ''
                List of allowed bupstash actions through the ssh connection.
                If none are specified then all actions are authorized.
              '';
            };
          };
        });
        default = { };
        description = "List of ssh keys with access to the repository.";
      };

      home = mkOption {
        type = passwdEntry path // {
          name = "path";
        };
        default = "/var/lib/${defaultRepositoryUser}";
        description = "The path where the repositories will be stored.";
      };

      restrictCommands = mkOption {
        type = bool;
        default = true;
        description = "If set to true, restricts the commands that can be run through ssh by the user to `bupstash ...`.";
      };
    };

    jobs = mkOption {
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              paths = mkOption {
                type = listOf path;
                default = [ ];
                example = [
                  "/var/lib"
                  "/var/backup"
                  "/home"
                ];
                description = ''
                  List of file and directory paths to include in the backup.
                '';
              };

              excludes = mkOption {
                type = listOf str;
                default = [ ];
                example = [
                  ".cache"
                  "*.tmp"
                  "*.bak[0-9]"
                ];
                description = ''
                  List of patterns to exlude from the backup. This is ignored if not uploading a directory snapshot.
                  The glob is matched against the absolute paths and should not end with a /.
                  Globs without a leading / or **/ are treated as file name matches, i.e. they are automatically prepended with **/.

                  Usual globbing rules apply:

                  - * matches everything on a level,
                  - ** matches any number of levels,
                  - ? matches a single character,
                  - […] matches a single character from a given character set (and can also be used to escape the other special characters: [?]).
                '';
              };

              command = mkOption {
                type = nullOr (listOf str);
                default = null;
                example = literalExpression ''
                  [ "''${lib.getBin config.services.postgresql.package}/bin/pgdump" "mydb" ]
                '';
                description = ''
                  Command to execute, where stdout is saved as an entry in the bupstash repository.
                  Only create the entry if the command exited with a successful status code.
                '';
              };

              key = mkOption {
                type = nullOr path;
                default = null;
                description = ''
                  Path to the key that will be used to encrypt the data.
                  See [the documentation](https://bupstash.io/doc/guides/Secure%20Offline%20Keys.html) to securely use keys.
                '';
              };

              keyCommand = mkOption {
                type = nullOr str;
                default = null;
                description = ''
                  Run a command that prints the key to stdout. Mutually exclusive with the `key` option.
                  Useful to retrieve the key from password managers.
                '';
              };

              user = mkOption {
                type = str;
                default = defaultClientUser;
                description = ''
                  User that executes the backup job. Will run as a [dynamic user](https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#DynamicUser=) by default.
                  If the backup needs to run under a static UID, declaring a user account with the same name is sufficient.
                '';
              };

              group = mkOption {
                type = nullOr str;
                default = null;
                description = "Group for the backup job. When no group is provided (the default behaviour).";
              };

              preHook = mkOption {
                type = lines;
                default = "";
                description = ''
                  Commands that are run before the put job is run. Executed with root permissions.
                  Useful to create snapshots and perform other preparations.
                '';
                example = literalExpression ''
                  # https://openzfs.github.io/openzfs-docs/man/8/zfs-snapshot.8.html
                  ''${config.boot.zfs.package}/bin/zfs snapshot -r pool/state@backup
                '';
              };

              postHook = mkOption {
                type = lines;
                default = "";
                description = ''
                  Commands that are run before the put job is run.
                  Useful to remove snapshots and perform other cleanup tasks.
                '';
                example = literalExpression ''
                  # https://openzfs.github.io/openzfs-docs/man/8/zfs-snapshot.8.html
                  ''${config.boot.zfs.package}/bin/zfs destroy -r pool/state@backup
                '';
              };

              repositories = mkOption {
                type = attrsOf str;
                default = { };
                description = ''
                  The repositories to connect to.
                  May be of the form `ssh://$SERVER/$PATH` for remote repositories if ssh access is configured.
                  This option will set the `BUPSTASH_REPOSITORY` variable.
                '';
                example = literalExpression ''
                  {
                    # For a local repository :
                    local = "/path/to/external/disk";

                    ssh = "ssh://toto@example.tld/secret/path";
                  };
                '';
              };

              repositoryCommands = mkOption {
                type = attrsOf str;
                default = { };
                description = ''
                  An attrset of command to run to connect to an instance of `bupstash-serve`.
                  This allows more complex connections to the repository for less common use cases.
                  This option will set the `BUPSTASH_REPOSITORY_COMMAND` variable.
                '';
                example = literalExpression ''
                  {
                    # For an ssh remote repo
                    remote = "ssh -i /run/agenix/ssh-privatekey toto@example.tld";
                  };
                '';
              };

              createRepositories = mkOption {
                type = listOf str;
                default = [ ];
                description = ''
                  List of repositories to automatically create.
                  The names must refer to an attribute of `repositories` or `repositoryCommand`.
                '';
              };

              tags = mkOption {
                type = attrsOf str;
                default = {
                  inherit name;
                };
                description = ''
                  Key/value pairs that are applied as tags for this job.
                  Valid tag keys must match the regular expression ^([a-zA-Z0-9\\-_]+)=(.+)$,
                  that means tag keys must be alpha numeric with the addition of - and _
                '';
              };

              startAt = mkOption {
                type = either str (listOf str);
                default = [ ];
                example = "*-*-* 02:30:00";
                description = ''
                  Automatically start this backup at the given date/time, which
                  must be in the format described in {manpage}`systemd.time(7)`.
                '';
              };

              extraArgs = mkOption {
                type = listOf str;
                default = [ ];
                description = ''
                  Additional options passed to the `bupstash put` command line.
                  Check the [documentation](https://bupstash.io/doc/man/bupstash-put.html) for possible options.
                '';
              };
            };
          }
        )
      );
      default = { };
      example = {
        home = {
          startAt = "*-*-* *:14:00";
          key = "/run/agenix/bupstash-home.put";

          repositories.remote = {
            createRepository = true;
            command = "ssh -i /run/agenix/ssh-privatekey toto@example.tld";
          };

          paths = [ "/home" ];
          excludes = [
            ".cache"
            ".mozilla"
            ".tmp"
            "*.iso"
          ];
        };
      };
      description = "Bupstash backup job configurations.";
    };
  };

  config = mkMerge [
    (mkIf (cfg.jobs != { }) {
      assertions = concatLists (
        mapAttrsToList (
          name: job:
          [
            {
              assertion = (job.key == null) != (job.keyCommand == null);
              message = "Exactly one of key and keyCommand must be provided for the ${name} job.";
            }
            {
              assertion = (job.paths == [ ]) != (job.command == null);
              message = "Exactly one of paths and command must be provided for the ${name} job.";
            }
            {
              assertion = allUnique ((attrNames job.repositories) ++ (attrNames job.repositoryCommands));
              message = "Repositories and repositoryCommands cannot share attribute names for the ${name} job.";
            }
          ]
          ++ (mapAttrsToList (name: repo: {
            assertion = (elem name job.createRepositories) -> (hasPrefix "ssh://" repo);
            message = ''
              Automatic repository creation is disabled for local repositories.
              Please run directly `bupstash-init -r ${repo}` and unset `createRepository`.
            '';
          }) job.repositories)
          ++ (map (repo: {
            assertion = hasAttr repo job.repositories || hasAttr repo job.repositoryCommands;
            message = "No repository '${name}' has been defined in `repositories` or `repositoryCommands` for the ${name} job.";
          }) job.createRepositories)
        ) cfg.jobs
      );

      systemd = {
        services = concatMapAttrs mkJobUnits cfg.jobs;
        timers = mapAttrs' mkJobTimer cfg.jobs;
        targets = mapAttrs' mkJobTarget cfg.jobs;
      };
    })

    (mkIf cfg.repositories.enable {
      users.users = mkIf (cfg.repositories.user == defaultRepositoryUser) {
        ${defaultRepositoryUser} = {
          inherit (cfg.repositories) group home;

          isSystemUser = true;
          createHome = true;
          useDefaultShell = true;

          openssh.authorizedKeys.keys = concatMap mkAuthorizedKeys cfg.repositories.access;

          packages = [ cfg.package ];
        };
      };

      users.groups = mkIf (cfg.repositories.group == defaultRepositoryUser) {
        ${defaultRepositoryUser} = { };
      };
    })
  ];
}
