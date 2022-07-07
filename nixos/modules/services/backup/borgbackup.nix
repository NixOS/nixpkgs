{ config, lib, pkgs, ... }:

with lib;

let

  isLocalPath = x:
    builtins.substring 0 1 x == "/"      # absolute path
    || builtins.substring 0 1 x == "."   # relative path
    || builtins.match "[.*:.*]" == null; # not machine:path

  mkExcludeFile = cfg:
    # Write each exclude pattern to a new line
    pkgs.writeText "excludefile" (concatStringsSep "\n" cfg.exclude);

  mkKeepArgs = cfg:
    # If cfg.prune.keep e.g. has a yearly attribute,
    # its content is passed on as --keep-yearly
    concatStringsSep " "
      (mapAttrsToList (x: y: "--keep-${x}=${toString y}") cfg.prune.keep);

  mkBackupScript = cfg: ''
    on_exit()
    {
      exitStatus=$?
      # Reset the EXIT handler, or else we're called again on 'exit' below
      trap - EXIT
      ${cfg.postHook}
      exit $exitStatus
    }
    trap 'on_exit' INT TERM QUIT EXIT

    archiveName="${if cfg.archiveBaseName == null then "" else cfg.archiveBaseName + "-"}$(date ${cfg.dateFormat})"
    archiveSuffix="${optionalString cfg.appendFailedSuffix ".failed"}"
    ${cfg.preHook}
  '' + optionalString cfg.doInit ''
    # Run borg init if the repo doesn't exist yet
    if ! borg list $extraArgs > /dev/null; then
      borg init $extraArgs \
        --encryption ${cfg.encryption.mode} \
        $extraInitArgs
      ${cfg.postInit}
    fi
  '' + ''
    (
      set -o pipefail
      ${optionalString (cfg.dumpCommand != null) ''${escapeShellArg cfg.dumpCommand} | \''}
      borg create $extraArgs \
        --compression ${cfg.compression} \
        --exclude-from ${mkExcludeFile cfg} \
        $extraCreateArgs \
        "::$archiveName$archiveSuffix" \
        ${if cfg.paths == null then "-" else escapeShellArgs cfg.paths}
    )
  '' + optionalString cfg.appendFailedSuffix ''
    borg rename $extraArgs \
      "::$archiveName$archiveSuffix" "$archiveName"
  '' + ''
    ${cfg.postCreate}
  '' + optionalString (cfg.prune.keep != { }) ''
    borg prune $extraArgs \
      ${mkKeepArgs cfg} \
      ${optionalString (cfg.prune.prefix != null) "--prefix ${escapeShellArg cfg.prune.prefix} \\"}
      $extraPruneArgs
    ${cfg.postPrune}
  '';

  mkPassEnv = cfg: with cfg.encryption;
    if passCommand != null then
      { BORG_PASSCOMMAND = passCommand; }
    else if passphrase != null then
      { BORG_PASSPHRASE = passphrase; }
    else { };

  mkBackupService = name: cfg:
    let
      userHome = config.users.users.${cfg.user}.home;
    in nameValuePair "borgbackup-job-${name}" {
      description = "BorgBackup job ${name}";
      path = with pkgs; [
        borgbackup openssh
      ];
      script = mkBackupScript cfg;
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        # Only run when no other process is using CPU or disk
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        ProtectSystem = "strict";
        ReadWritePaths =
          [ "${userHome}/.config/borg" "${userHome}/.cache/borg" ]
          ++ cfg.readWritePaths
          # Borg needs write access to repo if it is not remote
          ++ optional (isLocalPath cfg.repo) cfg.repo;
        PrivateTmp = cfg.privateTmp;
      };
      environment = {
        BORG_REPO = cfg.repo;
        inherit (cfg) extraArgs extraInitArgs extraCreateArgs extraPruneArgs;
      } // (mkPassEnv cfg) // cfg.environment;
    };

  mkBackupTimers = name: cfg:
    nameValuePair "borgbackup-job-${name}" {
      description = "BorgBackup job ${name} timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Persistent = cfg.persistentTimer;
        OnCalendar = cfg.startAt;
      };
      # if remote-backup wait for network
      after = optional (cfg.persistentTimer && !isLocalPath cfg.repo) "network-online.target";
    };

  # utility function around makeWrapper
  mkWrapperDrv = {
      original, name, set ? {}
    }:
    pkgs.runCommand "${name}-wrapper" {
      buildInputs = [ pkgs.makeWrapper ];
    } (with lib; ''
      makeWrapper "${original}" "$out/bin/${name}" \
        ${concatStringsSep " \\\n " (mapAttrsToList (name: value: ''--set ${name} "${value}"'') set)}
    '');

  mkBorgWrapper = name: cfg: mkWrapperDrv {
    original = "${pkgs.borgbackup}/bin/borg";
    name = "borg-job-${name}";
    set = { BORG_REPO = cfg.repo; } // (mkPassEnv cfg) // cfg.environment;
  };

  # Paths listed in ReadWritePaths must exist before service is started
  mkActivationScript = name: cfg:
    let
      install = "install -o ${cfg.user} -g ${cfg.group}";
    in
      nameValuePair "borgbackup-job-${name}" (stringAfter [ "users" ] (''
        # Ensure that the home directory already exists
        # We can't assert createHome == true because that's not the case for root
        cd "${config.users.users.${cfg.user}.home}"
        ${install} -d .config/borg
        ${install} -d .cache/borg
      '' + optionalString (isLocalPath cfg.repo && !cfg.removableDevice) ''
        ${install} -d ${escapeShellArg cfg.repo}
      ''));

  mkPassAssertion = name: cfg: {
    assertion = with cfg.encryption;
      mode != "none" -> passCommand != null || passphrase != null;
    message =
      "passCommand or passphrase has to be specified because"
      + '' borgbackup.jobs.${name}.encryption != "none"'';
  };

  mkRepoService = name: cfg:
    nameValuePair "borgbackup-repo-${name}" {
      description = "Create BorgBackup repository ${name} directory";
      script = ''
        mkdir -p ${escapeShellArg cfg.path}
        chown ${cfg.user}:${cfg.group} ${escapeShellArg cfg.path}
      '';
      serviceConfig = {
        # The service's only task is to ensure that the specified path exists
        Type = "oneshot";
      };
      wantedBy = [ "multi-user.target" ];
    };

  mkAuthorizedKey = cfg: appendOnly: key:
    let
      # Because of the following line, clients do not need to specify an absolute repo path
      cdCommand = "cd ${escapeShellArg cfg.path}";
      restrictedArg = "--restrict-to-${if cfg.allowSubRepos then "path" else "repository"} .";
      appendOnlyArg = optionalString appendOnly "--append-only";
      quotaArg = optionalString (cfg.quota != null) "--storage-quota ${cfg.quota}";
      serveCommand = "borg serve ${restrictedArg} ${appendOnlyArg} ${quotaArg}";
    in
      ''command="${cdCommand} && ${serveCommand}",restrict ${key}'';

  mkUsersConfig = name: cfg: {
    users.${cfg.user} = {
      openssh.authorizedKeys.keys =
        (map (mkAuthorizedKey cfg false) cfg.authorizedKeys
        ++ map (mkAuthorizedKey cfg true) cfg.authorizedKeysAppendOnly);
      useDefaultShell = true;
      group = cfg.group;
      isSystemUser = true;
    };
    groups.${cfg.group} = { };
  };

  mkKeysAssertion = name: cfg: {
    assertion = cfg.authorizedKeys != [ ] || cfg.authorizedKeysAppendOnly != [ ];
    message =
      "borgbackup.repos.${name} does not make sense"
      + " without at least one public key";
  };

  mkSourceAssertions = name: cfg: {
    assertion = count isNull [ cfg.dumpCommand cfg.paths ] == 1;
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

in {
  meta.maintainers = with maintainers; [ dotlambda ];
  meta.doc = ./borgbackup.xml;

  ###### interface

  options.services.borgbackup.jobs = mkOption {
    description = ''
      Deduplicating backups using BorgBackup.
      Adding a job will cause a borg-job-NAME wrapper to be added
      to your system path, so that you can perform maintenance easily.
      See also the chapter about BorgBackup in the NixOS manual.
    '';
    default = { };
    example = literalExpression ''
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
    type = types.attrsOf (types.submodule (let globalConfig = config; in
      { name, config, ... }: {
        options = {

          paths = mkOption {
            type = with types; nullOr (coercedTo str lib.singleton (listOf str));
            default = null;
            description = ''
              Path(s) to back up.
              Mutually exclusive with <option>dumpCommand</option>.
            '';
            example = "/home/user";
          };

          dumpCommand = mkOption {
            type = with types; nullOr path;
            default = null;
            description = ''
              Backup the stdout of this program instead of filesystem paths.
              Mutually exclusive with <option>paths</option>.
            '';
            example = "/path/to/createZFSsend.sh";
          };

          repo = mkOption {
            type = types.str;
            description = "Remote or local repository to back up to.";
            example = "user@machine:/path/to/repo";
          };

          removableDevice = mkOption {
            type = types.bool;
            default = false;
            description = "Whether the repo (which must be local) is a removable device.";
          };

          archiveBaseName = mkOption {
            type = types.nullOr (types.strMatching "[^/{}]+");
            default = "${globalConfig.networking.hostName}-${name}";
            defaultText = literalExpression ''"''${config.networking.hostName}-<name>"'';
            description = ''
              How to name the created archives. A timestamp, whose format is
              determined by <option>dateFormat</option>, will be appended. The full
              name can be modified at runtime (<literal>$archiveName</literal>).
              Placeholders like <literal>{hostname}</literal> must not be used.
              Use <literal>null</literal> for no base name.
            '';
          };

          dateFormat = mkOption {
            type = types.str;
            description = ''
              Arguments passed to <command>date</command>
              to create a timestamp suffix for the archive name.
            '';
            default = "+%Y-%m-%dT%H:%M:%S";
            example = "-u +%s";
          };

          startAt = mkOption {
            type = with types; either str (listOf str);
            default = "daily";
            description = ''
              When or how often the backup should run.
              Must be in the format described in
              <citerefentry><refentrytitle>systemd.time</refentrytitle>
              <manvolnum>7</manvolnum></citerefentry>.
              If you do not want the backup to start
              automatically, use <literal>[ ]</literal>.
              It will generate a systemd service borgbackup-job-NAME.
              You may trigger it manually via systemctl restart borgbackup-job-NAME.
            '';
          };

          persistentTimer = mkOption {
            default = false;
            type = types.bool;
            example = true;
            description = ''
              Set the <literal>persistentTimer</literal> option for the
              <citerefentry><refentrytitle>systemd.timer</refentrytitle>
              <manvolnum>5</manvolnum></citerefentry>
              which triggers the backup immediately if the last trigger
              was missed (e.g. if the system was powered down).
            '';
          };

          user = mkOption {
            type = types.str;
            description = ''
              The user <command>borg</command> is run as.
              User or group need read permission
              for the specified <option>paths</option>.
            '';
            default = "root";
          };

          group = mkOption {
            type = types.str;
            description = ''
              The group borg is run as. User or group needs read permission
              for the specified <option>paths</option>.
            '';
            default = "root";
          };

          encryption.mode = mkOption {
            type = types.enum [
              "repokey" "keyfile"
              "repokey-blake2" "keyfile-blake2"
              "authenticated" "authenticated-blake2"
              "none"
            ];
            description = ''
              Encryption mode to use. Setting a mode
              other than <literal>"none"</literal> requires
              you to specify a <option>passCommand</option>
              or a <option>passphrase</option>.
            '';
            example = "repokey-blake2";
          };

          encryption.passCommand = mkOption {
            type = with types; nullOr str;
            description = ''
              A command which prints the passphrase to stdout.
              Mutually exclusive with <option>passphrase</option>.
            '';
            default = null;
            example = "cat /path/to/passphrase_file";
          };

          encryption.passphrase = mkOption {
            type = with types; nullOr str;
            description = ''
              The passphrase the backups are encrypted with.
              Mutually exclusive with <option>passCommand</option>.
              If you do not want the passphrase to be stored in the
              world-readable Nix store, use <option>passCommand</option>.
            '';
            default = null;
          };

          compression = mkOption {
            # "auto" is optional,
            # compression mode must be given,
            # compression level is optional
            type = types.strMatching "none|(auto,)?(lz4|zstd|zlib|lzma)(,[[:digit:]]{1,2})?";
            description = ''
              Compression method to use. Refer to
              <command>borg help compression</command>
              for all available options.
            '';
            default = "lz4";
            example = "auto,lzma";
          };

          exclude = mkOption {
            type = with types; listOf str;
            description = ''
              Exclude paths matching any of the given patterns. See
              <command>borg help patterns</command> for pattern syntax.
            '';
            default = [ ];
            example = [
              "/home/*/.cache"
              "/nix"
            ];
          };

          readWritePaths = mkOption {
            type = with types; listOf path;
            description = ''
              By default, borg cannot write anywhere on the system but
              <literal>$HOME/.config/borg</literal> and <literal>$HOME/.cache/borg</literal>.
              If, for example, your preHook script needs to dump files
              somewhere, put those directories here.
            '';
            default = [ ];
            example = [
              "/var/backup/mysqldump"
            ];
          };

          privateTmp = mkOption {
            type = types.bool;
            description = ''
              Set the <literal>PrivateTmp</literal> option for
              the systemd-service. Set to false if you need sockets
              or other files from global /tmp.
            '';
            default = true;
          };

          doInit = mkOption {
            type = types.bool;
            description = ''
              Run <command>borg init</command> if the
              specified <option>repo</option> does not exist.
              You should set this to <literal>false</literal>
              if the repository is located on an external drive
              that might not always be mounted.
            '';
            default = true;
          };

          appendFailedSuffix = mkOption {
            type = types.bool;
            description = ''
              Append a <literal>.failed</literal> suffix
              to the archive name, which is only removed if
              <command>borg create</command> has a zero exit status.
            '';
            default = true;
          };

          prune.keep = mkOption {
            # Specifying e.g. `prune.keep.yearly = -1`
            # means there is no limit of yearly archives to keep
            # The regex is for use with e.g. --keep-within 1y
            type = with types; attrsOf (either int (strMatching "[[:digit:]]+[Hdwmy]"));
            description = ''
              Prune a repository by deleting all archives not matching any of the
              specified retention options. See <command>borg help prune</command>
              for the available options.
            '';
            default = { };
            example = literalExpression ''
              {
                within = "1d"; # Keep all archives from the last day
                daily = 7;
                weekly = 4;
                monthly = -1;  # Keep at least one archive for each month
              }
            '';
          };

          prune.prefix = mkOption {
            type = types.nullOr (types.str);
            description = ''
              Only consider archive names starting with this prefix for pruning.
              By default, only archives created by this job are considered.
              Use <literal>""</literal> or <literal>null</literal> to consider all archives.
            '';
            default = config.archiveBaseName;
            defaultText = literalExpression "archiveBaseName";
          };

          environment = mkOption {
            type = with types; attrsOf str;
            description = ''
              Environment variables passed to the backup script.
              You can for example specify which SSH key to use.
            '';
            default = { };
            example = { BORG_RSH = "ssh -i /path/to/key"; };
          };

          preHook = mkOption {
            type = types.lines;
            description = ''
              Shell commands to run before the backup.
              This can for example be used to mount file systems.
            '';
            default = "";
            example = ''
              # To add excluded paths at runtime
              extraCreateArgs="$extraCreateArgs --exclude /some/path"
            '';
          };

          postInit = mkOption {
            type = types.lines;
            description = ''
              Shell commands to run after <command>borg init</command>.
            '';
            default = "";
          };

          postCreate = mkOption {
            type = types.lines;
            description = ''
              Shell commands to run after <command>borg create</command>. The name
              of the created archive is stored in <literal>$archiveName</literal>.
            '';
            default = "";
          };

          postPrune = mkOption {
            type = types.lines;
            description = ''
              Shell commands to run after <command>borg prune</command>.
            '';
            default = "";
          };

          postHook = mkOption {
            type = types.lines;
            description = ''
              Shell commands to run just before exit. They are executed
              even if a previous command exits with a non-zero exit code.
              The latter is available as <literal>$exitStatus</literal>.
            '';
            default = "";
          };

          extraArgs = mkOption {
            type = types.str;
            description = ''
              Additional arguments for all <command>borg</command> calls the
              service has. Handle with care.
            '';
            default = "";
            example = "--remote-path=/path/to/borg";
          };

          extraInitArgs = mkOption {
            type = types.str;
            description = ''
              Additional arguments for <command>borg init</command>.
              Can also be set at runtime using <literal>$extraInitArgs</literal>.
            '';
            default = "";
            example = "--append-only";
          };

          extraCreateArgs = mkOption {
            type = types.str;
            description = ''
              Additional arguments for <command>borg create</command>.
              Can also be set at runtime using <literal>$extraCreateArgs</literal>.
            '';
            default = "";
            example = "--stats --checkpoint-interval 600";
          };

          extraPruneArgs = mkOption {
            type = types.str;
            description = ''
              Additional arguments for <command>borg prune</command>.
              Can also be set at runtime using <literal>$extraPruneArgs</literal>.
            '';
            default = "";
            example = "--save-space";
          };

        };
      }
    ));
  };

  options.services.borgbackup.repos = mkOption {
    description = ''
      Serve BorgBackup repositories to given public SSH keys,
      restricting their access to the repository only.
      See also the chapter about BorgBackup in the NixOS manual.
      Also, clients do not need to specify the absolute path when accessing the repository,
      i.e. <literal>user@machine:.</literal> is enough. (Note colon and dot.)
    '';
    default = { };
    type = types.attrsOf (types.submodule (
      { ... }: {
        options = {
          path = mkOption {
            type = types.path;
            description = ''
              Where to store the backups. Note that the directory
              is created automatically, with correct permissions.
            '';
            default = "/var/lib/borgbackup";
          };

          user = mkOption {
            type = types.str;
            description = ''
              The user <command>borg serve</command> is run as.
              User or group needs write permission
              for the specified <option>path</option>.
            '';
            default = "borg";
          };

          group = mkOption {
            type = types.str;
            description = ''
              The group <command>borg serve</command> is run as.
              User or group needs write permission
              for the specified <option>path</option>.
            '';
            default = "borg";
          };

          authorizedKeys = mkOption {
            type = with types; listOf str;
            description = ''
              Public SSH keys that are given full write access to this repository.
              You should use a different SSH key for each repository you write to, because
              the specified keys are restricted to running <command>borg serve</command>
              and can only access this single repository.
            '';
            default = [ ];
          };

          authorizedKeysAppendOnly = mkOption {
            type = with types; listOf str;
            description = ''
              Public SSH keys that can only be used to append new data (archives) to the repository.
              Note that archives can still be marked as deleted and are subsequently removed from disk
              upon accessing the repo with full write access, e.g. when pruning.
            '';
            default = [ ];
          };

          allowSubRepos = mkOption {
            type = types.bool;
            description = ''
              Allow clients to create repositories in subdirectories of the
              specified <option>path</option>. These can be accessed using
              <literal>user@machine:path/to/subrepo</literal>. Note that a
              <option>quota</option> applies to repositories independently.
              Therefore, if this is enabled, clients can create multiple
              repositories and upload an arbitrary amount of data.
            '';
            default = false;
          };

          quota = mkOption {
            # See the definition of parse_file_size() in src/borg/helpers/parseformat.py
            type = with types; nullOr (strMatching "[[:digit:].]+[KMGTP]?");
            description = ''
              Storage quota for the repository. This quota is ensured for all
              sub-repositories if <option>allowSubRepos</option> is enabled
              but not for the overall storage space used.
            '';
            default = null;
            example = "100G";
          };

        };
      }
    ));
  };

  ###### implementation

  config = mkIf (with config.services.borgbackup; jobs != { } || repos != { })
    (with config.services.borgbackup; {
      assertions =
        mapAttrsToList mkPassAssertion jobs
        ++ mapAttrsToList mkKeysAssertion repos
        ++ mapAttrsToList mkSourceAssertions jobs
        ++ mapAttrsToList mkRemovableDeviceAssertions jobs;

      system.activationScripts = mapAttrs' mkActivationScript jobs;

      systemd.services =
        # A job named "foo" is mapped to systemd.services.borgbackup-job-foo
        mapAttrs' mkBackupService jobs
        # A repo named "foo" is mapped to systemd.services.borgbackup-repo-foo
        // mapAttrs' mkRepoService repos;

      # A job named "foo" is mapped to systemd.timers.borgbackup-job-foo
      # only generate the timer if interval (startAt) is set
      systemd.timers = mapAttrs' mkBackupTimers (filterAttrs (_: cfg: cfg.startAt != []) jobs);

      users = mkMerge (mapAttrsToList mkUsersConfig repos);

      environment.systemPackages = with pkgs; [ borgbackup ] ++ (mapAttrsToList mkBorgWrapper jobs);
    });
}
