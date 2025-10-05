{
  config,
  lib,
  pkgs,
  ...
}:
let

  isLocalPath =
    x:
    builtins.substring 0 1 x == "/" # absolute path
    || builtins.substring 0 1 x == "." # relative path
    || builtins.match "[.*:.*]" == null; # not machine:path

  mkExcludeFile =
    cfg:
    # Write each exclude pattern to a new line
    pkgs.writeText "excludefile" (lib.concatMapStrings (s: s + "\n") cfg.exclude);

  mkPatternsFile =
    cfg:
    # Write each pattern to a new line
    pkgs.writeText "patternsfile" (lib.concatMapStrings (s: s + "\n") cfg.patterns);

  mkKeepArgs =
    cfg:
    # If cfg.prune.keep e.g. has a yearly attribute,
    # its content is passed on as --keep-yearly
    lib.concatStringsSep " " (lib.mapAttrsToList (x: y: "--keep-${x}=${toString y}") cfg.prune.keep);

  mkExtraArgs =
    cfg:
    # Create BASH arrays of extra args
    lib.concatLines (
      lib.mapAttrsToList
        (name: values: ''
          ${name}=(${values})
        '')
        {
          inherit (cfg)
            extraArgs
            extraInitArgs
            extraCreateArgs
            extraPruneArgs
            extraCompactArgs
            ;
        }
    );

  mkBackupScript =
    name: cfg:
    pkgs.writeShellScript "${name}-script" (
      ''
        set -e

        ${mkExtraArgs cfg}

        on_exit()
        {
          exitStatus=$?
          ${cfg.postHook}
          exit $exitStatus
        }
        trap on_exit EXIT

        borgWrapper () {
          local result
          borg "$@" && result=$? || result=$?
          if [[ -z "${toString cfg.failOnWarnings}" ]] && [[ "$result" == 1 || ("$result" -ge 100 && "$result" -le 127) ]]; then
            echo "ignoring warning return value $result"
            return 0
          else
            return "$result"
          fi
        }

        archiveName="${
          lib.optionalString (cfg.archiveBaseName != null) (cfg.archiveBaseName + "-")
        }$(date ${cfg.dateFormat})"
        archiveSuffix="${lib.optionalString cfg.appendFailedSuffix ".failed"}"
        ${cfg.preHook}
      ''
      + lib.optionalString cfg.doInit ''
        # Run borg init if the repo doesn't exist yet
        if ! borgWrapper list "''${extraArgs[@]}" > /dev/null; then
          borgWrapper init "''${extraArgs[@]}" \
            --encryption ${cfg.encryption.mode} \
            "''${extraInitArgs[@]}"
          ${cfg.postInit}
        fi
      ''
      + ''
        (
          set -o pipefail
          ${lib.optionalString (cfg.dumpCommand != null) ''${lib.escapeShellArg cfg.dumpCommand} | \''}
          borgWrapper create "''${extraArgs[@]}" \
            --compression ${cfg.compression} \
            --exclude-from ${mkExcludeFile cfg} \
            --patterns-from ${mkPatternsFile cfg} \
            "''${extraCreateArgs[@]}" \
            "::$archiveName$archiveSuffix" \
            ${if cfg.paths == null then "-" else lib.escapeShellArgs cfg.paths}
        )
      ''
      + lib.optionalString cfg.appendFailedSuffix ''
        borgWrapper rename "''${extraArgs[@]}" \
          "::$archiveName$archiveSuffix" "$archiveName"
      ''
      + ''
        ${cfg.postCreate}
      ''
      + lib.optionalString (cfg.prune.keep != { }) ''
        borgWrapper prune "''${extraArgs[@]}" \
          ${mkKeepArgs cfg} \
          ${
            lib.optionalString (
              cfg.prune.prefix != null
            ) "--glob-archives ${lib.escapeShellArg "${cfg.prune.prefix}*"}"
          } \
          "''${extraPruneArgs[@]}"
        borgWrapper compact "''${extraArgs[@]}" "''${extraCompactArgs[@]}"
        ${cfg.postPrune}
      ''
    );

  mkPassEnv =
    cfg:
    with cfg.encryption;
    if passCommand != null then
      { BORG_PASSCOMMAND = passCommand; }
    else if passphrase != null then
      { BORG_PASSPHRASE = passphrase; }
    else
      { };

  mkBackupService =
    name: cfg:
    let
      userHome = config.users.users.${cfg.user}.home;
      backupJobName = "borgbackup-job-${name}";
      backupScript = mkBackupScript backupJobName cfg;
    in
    lib.nameValuePair backupJobName {
      description = "BorgBackup job ${name}";
      path = [
        config.services.borgbackup.package
        pkgs.openssh
      ];
      script =
        "exec "
        + lib.optionalString cfg.inhibitsSleep ''
          ${pkgs.systemd}/bin/systemd-inhibit \
              --who="borgbackup" \
              --what="sleep" \
              --why="Scheduled backup" \
        ''
        + backupScript;
      unitConfig = lib.optionalAttrs (isLocalPath cfg.repo) {
        RequiresMountsFor = [ cfg.repo ];
      };
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        # Only run when no other process is using CPU or disk
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        ProtectSystem = "strict";
        ReadWritePaths = [
          "${userHome}/.config/borg"
          "${userHome}/.cache/borg"
        ]
        ++ cfg.readWritePaths
        # Borg needs write access to repo if it is not remote
        ++ lib.optional (isLocalPath cfg.repo) cfg.repo;
        PrivateTmp = cfg.privateTmp;
      };
      environment = {
        BORG_REPO = cfg.repo;
      }
      // (mkPassEnv cfg)
      // cfg.environment;
    };

  mkBackupTimers =
    name: cfg:
    lib.nameValuePair "borgbackup-job-${name}" {
      description = "BorgBackup job ${name} timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Persistent = cfg.persistentTimer;
        OnCalendar = cfg.startAt;
      };
      # if remote-backup wait for network
      after = lib.optional (cfg.persistentTimer && !isLocalPath cfg.repo) "network-online.target";
      wants = lib.optional (cfg.persistentTimer && !isLocalPath cfg.repo) "network-online.target";
    };

  # utility function around makeWrapper
  mkWrapperDrv =
    {
      original,
      name,
      set ? { },
    }:
    pkgs.runCommand "${name}-wrapper"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      }
      (
        with lib;
        ''
          makeWrapper "${original}" "$out/bin/${name}" \
            ${lib.concatStringsSep " \\\n " (
              lib.mapAttrsToList (name: value: ''--set ${name} "${value}"'') set
            )}
        ''
      );

  # Returns a singleton list, due to usage of lib.optional
  mkBorgWrapper =
    name: cfg:
    lib.optional (cfg.wrapper != "" && cfg.wrapper != null) (mkWrapperDrv {
      original = lib.getExe config.services.borgbackup.package;
      name = cfg.wrapper;
      set = {
        BORG_REPO = cfg.repo;
      }
      // (mkPassEnv cfg)
      // cfg.environment;
    });

  # Paths listed in ReadWritePaths must exist before service is started
  mkTmpfiles =
    name: cfg:
    let
      settings = { inherit (cfg) user group; };
    in
    lib.nameValuePair "borgbackup-job-${name}" (
      {
        # Create parent dirs separately, to ensure correct ownership.
        "${config.users.users."${cfg.user}".home}/.config".d = settings;
        "${config.users.users."${cfg.user}".home}/.cache".d = settings;
        "${config.users.users."${cfg.user}".home}/.config/borg".d = settings;
        "${config.users.users."${cfg.user}".home}/.cache/borg".d = settings;
      }
      // lib.optionalAttrs (isLocalPath cfg.repo && !cfg.removableDevice) {
        "${cfg.repo}".d = settings;
      }
    );

  mkPassAssertion = name: cfg: {
    assertion = with cfg.encryption; mode != "none" -> passCommand != null || passphrase != null;
    message =
      "passCommand or passphrase has to be specified because"
      + " borgbackup.jobs.${name}.encryption != \"none\"";
  };

  mkRepoService =
    name: cfg:
    lib.nameValuePair "borgbackup-repo-${name}" {
      description = "Create BorgBackup repository ${name} directory";
      script = ''
        mkdir -p ${lib.escapeShellArg cfg.path}
        chown ${cfg.user}:${cfg.group} ${lib.escapeShellArg cfg.path}
      '';
      serviceConfig = {
        # The service's only task is to ensure that the specified path exists
        Type = "oneshot";
      };
      wantedBy = [ "multi-user.target" ];
    };

  mkAuthorizedKey =
    cfg: appendOnly: key:
    let
      # Because of the following line, clients do not need to specify an absolute repo path
      cdCommand = "cd ${lib.escapeShellArg cfg.path}";
      restrictedArg = "--restrict-to-${if cfg.allowSubRepos then "path" else "repository"} .";
      appendOnlyArg = lib.optionalString appendOnly "--append-only";
      quotaArg = lib.optionalString (cfg.quota != null) "--storage-quota ${cfg.quota}";
      serveCommand = "borg serve ${restrictedArg} ${appendOnlyArg} ${quotaArg}";
    in
    ''command="${cdCommand} && ${serveCommand}",restrict ${key}'';

  mkUsersConfig = name: cfg: {
    users.${cfg.user} = {
      openssh.authorizedKeys.keys = (
        map (mkAuthorizedKey cfg false) cfg.authorizedKeys
        ++ map (mkAuthorizedKey cfg true) cfg.authorizedKeysAppendOnly
      );
      useDefaultShell = true;
      group = cfg.group;
      isSystemUser = true;
    };
    groups.${cfg.group} = { };
  };

  mkKeysAssertion = name: cfg: {
    assertion = cfg.authorizedKeys != [ ] || cfg.authorizedKeysAppendOnly != [ ];
    message = "borgbackup.repos.${name} does not make sense" + " without at least one public key";
  };

  mkSourceAssertions = name: cfg: {
    assertion =
      lib.count isNull [
        cfg.dumpCommand
        cfg.paths
      ] == 1;
    message = ''
      Exactly one of borgbackup.jobs.${name}.paths or borgbackup.jobs.${name}.dumpCommand
      must be set.
    '';
  };

  mkRemovableDeviceAssertions = name: cfg: {
    assertion = !(isLocalPath cfg.repo) -> !cfg.removableDevice;
    message = ''
      borgbackup.repos.${name}: repo isn't a local path, thus it can't be a removable device!
    '';
  };

in
{
  meta.maintainers = with lib.maintainers; [
    dotlambda
    Scrumplex
  ];
  meta.doc = ./borgbackup.md;

  ###### interface

  options.services.borgbackup.package = lib.mkPackageOption pkgs "borgbackup" { };

  options.services.borgbackup.jobs = lib.mkOption {
    description = ''
      Deduplicating backups using BorgBackup.
      Adding a job will cause a borg-job-NAME wrapper to be added
      to your system path, so that you can perform maintenance easily.
      See also the chapter about BorgBackup in the NixOS manual.
    '';
    default = { };
    example = lib.literalExpression ''
        { # for a local backup
          rootBackup = {
            paths = "/";
            exclude = [ "/nix" ];
            repo = "/path/to/local/repo";
            encryption = {
              mode = "repokey";
              passphrase = "secret";
            };
            compression = "auto,lzma";
            startAt = "weekly";
          };
        }
        { # Root backing each day up to a remote backup server. We assume that you have
          #   * created a password less key: ssh-keygen -N "" -t ed25519 -f /path/to/ssh_key
          #     best practices are: use -t ed25519, /path/to = /run/keys
          #   * the passphrase is in the file /run/keys/borgbackup_passphrase
          #   * you have initialized the repository manually
          paths = [ "/etc" "/home" ];
          exclude = [ "/nix" "'**/.cache'" ];
          doInit = false;
          repo =  "user3@arep.repo.borgbase.com:repo";
          encryption = {
            mode = "repokey-blake2";
            passCommand = "cat /path/to/passphrase";
          };
          environment = { BORG_RSH = "ssh -i /path/to/ssh_key"; };
          compression = "auto,lzma";
          startAt = "daily";
      };
    '';
    type = lib.types.attrsOf (
      lib.types.submodule (
        let
          globalConfig = config;
        in
        { name, config, ... }:
        {
          options = {

            paths = lib.mkOption {
              type = with lib.types; nullOr (coercedTo str lib.singleton (listOf str));
              default = null;
              description = ''
                Path(s) to back up.
                Mutually exclusive with {option}`dumpCommand`.
              '';
              example = "/home/user";
            };

            dumpCommand = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              description = ''
                Backup the stdout of this program instead of filesystem paths.
                Mutually exclusive with {option}`paths`.
              '';
              example = "/path/to/createZFSsend.sh";
            };

            repo = lib.mkOption {
              type = lib.types.str;
              description = "Remote or local repository to back up to.";
              example = "user@machine:/path/to/repo";
            };

            removableDevice = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether the repo (which must be local) is a removable device.";
            };

            archiveBaseName = lib.mkOption {
              type = lib.types.nullOr (lib.types.strMatching "[^/{}]+");
              default = "${globalConfig.networking.hostName}-${name}";
              defaultText = lib.literalExpression ''"''${config.networking.hostName}-<name>"'';
              description = ''
                How to name the created archives. A timestamp, whose format is
                determined by {option}`dateFormat`, will be appended. The full
                name can be modified at runtime (`$archiveName`).
                Placeholders like `{hostname}` must not be used.
                Use `null` for no base name.
              '';
            };

            dateFormat = lib.mkOption {
              type = lib.types.str;
              description = ''
                Arguments passed to {command}`date`
                to create a timestamp suffix for the archive name.
              '';
              default = "+%Y-%m-%dT%H:%M:%S";
              example = "-u +%s";
            };

            startAt = lib.mkOption {
              type = with lib.types; either str (listOf str);
              default = "daily";
              description = ''
                When or how often the backup should run.
                Must be in the format described in
                {manpage}`systemd.time(7)`.
                If you do not want the backup to start
                automatically, use `[ ]`.
                It will generate a systemd service borgbackup-job-NAME.
                You may trigger it manually via systemctl restart borgbackup-job-NAME.
              '';
            };

            persistentTimer = lib.mkOption {
              default = false;
              type = lib.types.bool;
              example = true;
              description = ''
                Set the `Persistent` option for the
                {manpage}`systemd.timer(5)`
                which triggers the backup immediately if the last trigger
                was missed (e.g. if the system was powered down).
              '';
            };

            inhibitsSleep = lib.mkOption {
              default = false;
              type = lib.types.bool;
              example = true;
              description = ''
                Prevents the system from sleeping while backing up.
              '';
            };

            user = lib.mkOption {
              type = lib.types.str;
              description = ''
                The user {command}`borg` is run as.
                User or group need read permission
                for the specified {option}`paths`.
              '';
              default = "root";
            };

            group = lib.mkOption {
              type = lib.types.str;
              description = ''
                The group borg is run as. User or group needs read permission
                for the specified {option}`paths`.
              '';
              default = "root";
            };

            wrapper = lib.mkOption {
              type = with lib.types; nullOr str;
              description = ''
                Name of the wrapper that is installed into {env}`PATH`.
                Set to `null` or `""` to disable it altogether.
              '';
              default = "borg-job-${name}";
              defaultText = "borg-job-<name>";
            };

            encryption.mode = lib.mkOption {
              type = lib.types.enum [
                "repokey"
                "keyfile"
                "repokey-blake2"
                "keyfile-blake2"
                "authenticated"
                "authenticated-blake2"
                "none"
              ];
              description = ''
                Encryption mode to use. Setting a mode
                other than `"none"` requires
                you to specify a {option}`passCommand`
                or a {option}`passphrase`.
              '';
              example = "repokey-blake2";
            };

            encryption.passCommand = lib.mkOption {
              type = with lib.types; nullOr str;
              description = ''
                A command which prints the passphrase to stdout.
                Mutually exclusive with {option}`passphrase`.
              '';
              default = null;
              example = "cat /path/to/passphrase_file";
            };

            encryption.passphrase = lib.mkOption {
              type = with lib.types; nullOr str;
              description = ''
                The passphrase the backups are encrypted with.
                Mutually exclusive with {option}`passCommand`.
                If you do not want the passphrase to be stored in the
                world-readable Nix store, use {option}`passCommand`.
              '';
              default = null;
            };

            compression = lib.mkOption {
              # "auto" is optional,
              # compression mode must be given,
              # compression level is optional
              type = lib.types.strMatching "none|(auto,)?(lz4|zstd|zlib|lzma)(,[[:digit:]]{1,2})?";
              description = ''
                Compression method to use. Refer to
                {command}`borg help compression`
                for all available options.
              '';
              default = "lz4";
              example = "auto,lzma";
            };

            exclude = lib.mkOption {
              type = with lib.types; listOf str;
              description = ''
                Exclude paths matching any of the given patterns. See
                {command}`borg help patterns` for pattern syntax.
              '';
              default = [ ];
              example = [
                "/home/*/.cache"
                "/nix"
              ];
            };

            patterns = lib.mkOption {
              type = with lib.types; listOf str;
              description = ''
                Include/exclude paths matching the given patterns. The first
                matching patterns is used, so if an include pattern (prefix `+`)
                matches before an exclude pattern (prefix `-`), the file is
                backed up. See [{command}`borg help patterns`](https://borgbackup.readthedocs.io/en/stable/usage/help.html#borg-patterns) for pattern syntax.
              '';
              default = [ ];
              example = [
                "+ /home/susan"
                "- /home/*"
              ];
            };

            readWritePaths = lib.mkOption {
              type = with lib.types; listOf path;
              description = ''
                By default, borg cannot write anywhere on the system but
                `$HOME/.config/borg` and `$HOME/.cache/borg`.
                If, for example, your preHook script needs to dump files
                somewhere, put those directories here.
              '';
              default = [ ];
              example = [
                "/var/backup/mysqldump"
              ];
            };

            privateTmp = lib.mkOption {
              type = lib.types.bool;
              description = ''
                Set the `PrivateTmp` option for
                the systemd-service. Set to false if you need sockets
                or other files from global /tmp.
              '';
              default = true;
            };

            failOnWarnings = lib.mkOption {
              type = lib.types.bool;
              description = ''
                Fail the whole backup job if any borg command returns a warning
                (exit code 1), for example because a file changed during backup.
              '';
              default = true;
            };

            doInit = lib.mkOption {
              type = lib.types.bool;
              description = ''
                Run {command}`borg init` if the
                specified {option}`repo` does not exist.
                You should set this to `false`
                if the repository is located on an external drive
                that might not always be mounted.
              '';
              default = true;
            };

            appendFailedSuffix = lib.mkOption {
              type = lib.types.bool;
              description = ''
                Append a `.failed` suffix
                to the archive name, which is only removed if
                {command}`borg create` has a zero exit status.
              '';
              default = true;
            };

            prune.keep = lib.mkOption {
              # Specifying e.g. `prune.keep.yearly = -1`
              # means there is no limit of yearly archives to keep
              # The regex is for use with e.g. --keep-within 1y
              type = with lib.types; attrsOf (either int (strMatching "[[:digit:]]+[Hdwmy]"));
              description = ''
                Prune a repository by deleting all archives not matching any of the
                specified retention options. See {command}`borg help prune`
                for the available options.
              '';
              default = { };
              example = lib.literalExpression ''
                {
                  within = "1d"; # Keep all archives from the last day
                  daily = 7;
                  weekly = 4;
                  monthly = -1;  # Keep at least one archive for each month
                }
              '';
            };

            prune.prefix = lib.mkOption {
              type = lib.types.nullOr (lib.types.str);
              description = ''
                Only consider archive names starting with this prefix for pruning.
                By default, only archives created by this job are considered.
                Use `""` or `null` to consider all archives.
              '';
              default = config.archiveBaseName;
              defaultText = lib.literalExpression "archiveBaseName";
            };

            environment = lib.mkOption {
              type = with lib.types; attrsOf str;
              description = ''
                Environment variables passed to the backup script.
                You can for example specify which SSH key to use.
              '';
              default = { };
              example = {
                BORG_RSH = "ssh -i /path/to/key";
              };
            };

            preHook = lib.mkOption {
              type = lib.types.lines;
              description = ''
                Shell commands to run before the backup.
                This can for example be used to mount file systems.
              '';
              default = "";
              example = ''
                # To add excluded paths at runtime
                extraCreateArgs+=("--exclude" "/some/path")
              '';
            };

            postInit = lib.mkOption {
              type = lib.types.lines;
              description = ''
                Shell commands to run after {command}`borg init`.
              '';
              default = "";
            };

            postCreate = lib.mkOption {
              type = lib.types.lines;
              description = ''
                Shell commands to run after {command}`borg create`. The name
                of the created archive is stored in `$archiveName`.
              '';
              default = "";
            };

            postPrune = lib.mkOption {
              type = lib.types.lines;
              description = ''
                Shell commands to run after {command}`borg prune`.
              '';
              default = "";
            };

            postHook = lib.mkOption {
              type = lib.types.lines;
              description = ''
                Shell commands to run just before exit. They are executed
                even if a previous command exits with a non-zero exit code.
                The latter is available as `$exitStatus`.
              '';
              default = "";
            };

            extraArgs = lib.mkOption {
              type = with lib.types; coercedTo (listOf str) lib.escapeShellArgs str;
              description = ''
                Additional arguments for all {command}`borg` calls the
                service has. Handle with care.
              '';
              default = [ ];
              example = [ "--remote-path=/path/to/borg" ];
            };

            extraInitArgs = lib.mkOption {
              type = with lib.types; coercedTo (listOf str) lib.escapeShellArgs str;
              description = ''
                Additional arguments for {command}`borg init`.
                Can also be set at runtime using `$extraInitArgs`.
              '';
              default = [ ];
              example = [ "--append-only" ];
            };

            extraCreateArgs = lib.mkOption {
              type = with lib.types; coercedTo (listOf str) lib.escapeShellArgs str;
              description = ''
                Additional arguments for {command}`borg create`.
                Can also be set at runtime using `$extraCreateArgs`.
              '';
              default = [ ];
              example = [
                "--stats"
                "--checkpoint-interval 600"
              ];
            };

            extraPruneArgs = lib.mkOption {
              type = with lib.types; coercedTo (listOf str) lib.escapeShellArgs str;
              description = ''
                Additional arguments for {command}`borg prune`.
                Can also be set at runtime using `$extraPruneArgs`.
              '';
              default = [ ];
              example = [ "--save-space" ];
            };

            extraCompactArgs = lib.mkOption {
              type = with lib.types; coercedTo (listOf str) lib.escapeShellArgs str;
              description = ''
                Additional arguments for {command}`borg compact`.
                Can also be set at runtime using `$extraCompactArgs`.
              '';
              default = [ ];
              example = [ "--cleanup-commits" ];
            };
          };
        }
      )
    );
  };

  options.services.borgbackup.repos = lib.mkOption {
    description = ''
      Serve BorgBackup repositories to given public SSH keys,
      restricting their access to the repository only.
      See also the chapter about BorgBackup in the NixOS manual.
      Also, clients do not need to specify the absolute path when accessing the repository,
      i.e. `user@machine:.` is enough. (Note colon and dot.)
    '';
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule (
        { ... }:
        {
          options = {
            path = lib.mkOption {
              type = lib.types.path;
              description = ''
                Where to store the backups. Note that the directory
                is created automatically, with correct permissions.
              '';
              default = "/var/lib/borgbackup";
            };

            user = lib.mkOption {
              type = lib.types.str;
              description = ''
                The user {command}`borg serve` is run as.
                User or group needs write permission
                for the specified {option}`path`.
              '';
              default = "borg";
            };

            group = lib.mkOption {
              type = lib.types.str;
              description = ''
                The group {command}`borg serve` is run as.
                User or group needs write permission
                for the specified {option}`path`.
              '';
              default = "borg";
            };

            authorizedKeys = lib.mkOption {
              type = with lib.types; listOf str;
              description = ''
                Public SSH keys that are given full write access to this repository.
                You should use a different SSH key for each repository you write to, because
                the specified keys are restricted to running {command}`borg serve`
                and can only access this single repository.
              '';
              default = [ ];
            };

            authorizedKeysAppendOnly = lib.mkOption {
              type = with lib.types; listOf str;
              description = ''
                Public SSH keys that can only be used to append new data (archives) to the repository.
                Note that archives can still be marked as deleted and are subsequently removed from disk
                upon accessing the repo with full write access, e.g. when pruning.
              '';
              default = [ ];
            };

            allowSubRepos = lib.mkOption {
              type = lib.types.bool;
              description = ''
                Allow clients to create repositories in subdirectories of the
                specified {option}`path`. These can be accessed using
                `user@machine:path/to/subrepo`. Note that a
                {option}`quota` applies to repositories independently.
                Therefore, if this is enabled, clients can create multiple
                repositories and upload an arbitrary amount of data.
              '';
              default = false;
            };

            quota = lib.mkOption {
              # See the definition of parse_file_size() in src/borg/helpers/parseformat.py
              type = with lib.types; nullOr (strMatching "[[:digit:].]+[KMGTP]?");
              description = ''
                Storage quota for the repository. This quota is ensured for all
                sub-repositories if {option}`allowSubRepos` is enabled
                but not for the overall storage space used.
              '';
              default = null;
              example = "100G";
            };

          };
        }
      )
    );
  };

  ###### implementation

  config = lib.mkIf (with config.services.borgbackup; jobs != { } || repos != { }) (
    with config.services.borgbackup;
    {
      assertions =
        lib.mapAttrsToList mkPassAssertion jobs
        ++ lib.mapAttrsToList mkKeysAssertion repos
        ++ lib.mapAttrsToList mkSourceAssertions jobs
        ++ lib.mapAttrsToList mkRemovableDeviceAssertions jobs;

      systemd.tmpfiles.settings = lib.mapAttrs' mkTmpfiles jobs;

      systemd.services =
        # A job named "foo" is mapped to systemd.services.borgbackup-job-foo
        lib.mapAttrs' mkBackupService jobs
        # A repo named "foo" is mapped to systemd.services.borgbackup-repo-foo
        // lib.mapAttrs' mkRepoService repos;

      # A job named "foo" is mapped to systemd.timers.borgbackup-job-foo
      # only generate the timer if interval (startAt) is set
      systemd.timers = lib.mapAttrs' mkBackupTimers (lib.filterAttrs (_: cfg: cfg.startAt != [ ]) jobs);

      users = lib.mkMerge (lib.mapAttrsToList mkUsersConfig repos);

      environment.systemPackages = [
        config.services.borgbackup.package
      ]
      ++ (lib.flatten (lib.mapAttrsToList mkBorgWrapper jobs));
    }
  );
}
