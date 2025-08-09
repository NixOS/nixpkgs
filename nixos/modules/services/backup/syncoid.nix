{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.syncoid;

  # Extract local dasaset names (so no datasets containing "@")
  localDatasetName =
    d:
    lib.optionals (d != null) (
      let
        m = builtins.match "([^/@]+[^@]*)" d;
      in
      lib.optionals (m != null) m
    );

  # Escape as required by: https://www.freedesktop.org/software/systemd/man/systemd.unit.html
  escapeUnitName =
    name:
    lib.concatMapStrings (s: if lib.isList s then "-" else s) (
      builtins.split "[^a-zA-Z0-9_.\\-]+" name
    );

  # Function to build "zfs allow" commands for the filesystems we've delegated
  # permissions to. It also checks if the target dataset exists before
  # delegating permissions, if it doesn't exist we delegate it to the parent
  # dataset (if it exists). This should solve the case of provisoning new
  # datasets.
  buildAllowCommand =
    permissions: dataset:
    (
      "-+${pkgs.writeShellScript "zfs-allow-${dataset}" ''
        # Here we explicitly use the booted system to guarantee the stable API needed by ZFS

        # Run a ZFS list on the dataset to check if it exists
        if ${
          lib.escapeShellArgs [
            "/run/booted-system/sw/bin/zfs"
            "list"
            dataset
          ]
        } 2> /dev/null; then
          ${lib.escapeShellArgs [
            "/run/booted-system/sw/bin/zfs"
            "allow"
            cfg.user
            (lib.concatStringsSep "," permissions)
            dataset
          ]}
        ${lib.optionalString ((builtins.dirOf dataset) != ".") ''
          else
            ${lib.escapeShellArgs [
              "/run/booted-system/sw/bin/zfs"
              "allow"
              cfg.user
              (lib.concatStringsSep "," permissions)
              # Remove the last part of the path
              (builtins.dirOf dataset)
            ]}
        ''}
        fi
      ''}"
    );

  # Function to build "zfs unallow" commands for the filesystems we've
  # delegated permissions to. Here we unallow both the target but also
  # on the parent dataset because at this stage we have no way of
  # knowing if the allow command did execute on the parent dataset or
  # not in the pre-hook. We can't run the same if in the post hook
  # since the dataset should have been created at this point.
  buildUnallowCommand =
    permissions: dataset:
    (
      "-+${pkgs.writeShellScript "zfs-unallow-${dataset}" ''
        # Here we explicitly use the booted system to guarantee the stable API needed by ZFS
        ${lib.escapeShellArgs [
          "/run/booted-system/sw/bin/zfs"
          "unallow"
          cfg.user
          (lib.concatStringsSep "," permissions)
          dataset
        ]}
        ${lib.optionalString ((builtins.dirOf dataset) != ".") (
          lib.escapeShellArgs [
            "/run/booted-system/sw/bin/zfs"
            "unallow"
            cfg.user
            (lib.concatStringsSep "," permissions)
            # Remove the last part of the path
            (builtins.dirOf dataset)
          ]
        )}
      ''}"
    );
in
{

  # Interface

  options.services.syncoid = {
    enable = lib.mkEnableOption "Syncoid ZFS synchronization service";

    package = lib.mkPackageOption pkgs "sanoid" { };

    interval = lib.mkOption {
      type = with lib.types; either str (listOf str);
      default = "hourly";
      example = "*-*-* *:15:00";
      description = ''
        Run syncoid at this interval. The default is to run hourly.

        Must be in the format described in {manpage}`systemd.time(7)`.  This is
        equivalent to adding a corresponding timer unit with
        {option}`OnCalendar` set to the value given here.

        Set to an empty list to avoid starting syncoid automatically.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "syncoid";
      example = "backup";
      description = ''
        The user for the service. ZFS privilege delegation will be
        automatically configured for any local pools used by syncoid if this
        option is set to a user other than root. The user will be given the
        "hold" and "send" privileges on any pool that has datasets being sent
        and the "create", "mount", "receive", and "rollback" privileges on
        any pool that has datasets being received.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "syncoid";
      example = "backup";
      description = "The group for the service.";
    };

    sshKey = lib.mkOption {
      type = with lib.types; nullOr (coercedTo path toString str);
      default = null;
      description = ''
        SSH private key file to use to login to the remote system. Can be
        overridden in individual commands.
      '';
    };

    localSourceAllow = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      # Permissions snapshot and destroy are in case --no-sync-snap is not used
      default = [
        "bookmark"
        "hold"
        "send"
        "snapshot"
        "destroy"
        "mount"
      ];
      description = ''
        Permissions granted for the {option}`services.syncoid.user` user
        for local source datasets. See
        <https://openzfs.github.io/openzfs-docs/man/8/zfs-allow.8.html>
        for available permissions.
      '';
    };

    localTargetAllow = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "change-key"
        "compression"
        "create"
        "mount"
        "mountpoint"
        "receive"
        "rollback"
      ];
      example = [
        "create"
        "mount"
        "receive"
        "rollback"
      ];
      description = ''
        Permissions granted for the {option}`services.syncoid.user` user
        for local target datasets. See
        <https://openzfs.github.io/openzfs-docs/man/8/zfs-allow.8.html>
        for available permissions.
        Make sure to include the `change-key` permission if you send raw encrypted datasets,
        the `compression` permission if you send raw compressed datasets, and so on.
        For remote target datasets you'll have to set your remote user permissions by yourself.
      '';
    };

    commonArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--no-sync-snap" ];
      description = ''
        Arguments to add to every syncoid command, unless disabled for that
        command. See
        <https://github.com/jimsalterjrs/sanoid/#syncoid-command-line-options>
        for available options.
      '';
    };

    service = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Systemd configuration common to all syncoid services.
      '';
    };

    commands = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              source = lib.mkOption {
                type = lib.types.str;
                example = "pool/dataset";
                description = ''
                  Source ZFS dataset. Can be either local or remote. Defaults to
                  the attribute name.
                '';
              };

              target = lib.mkOption {
                type = lib.types.str;
                example = "user@server:pool/dataset";
                description = ''
                  Target ZFS dataset. Can be either local
                  («pool/dataset») or remote
                  («user@server:pool/dataset»).
                '';
              };

              recursive = lib.mkEnableOption ''the transfer of child datasets'';

              sshKey = lib.mkOption {
                type = with lib.types; nullOr (coercedTo path toString str);
                description = ''
                  SSH private key file to use to login to the remote system.
                  Defaults to {option}`services.syncoid.sshKey` option.
                '';
              };

              localSourceAllow = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                description = ''
                  Permissions granted for the {option}`services.syncoid.user` user
                  for local source datasets. See
                  <https://openzfs.github.io/openzfs-docs/man/8/zfs-allow.8.html>
                  for available permissions.
                  Defaults to {option}`services.syncoid.localSourceAllow` option.
                '';
              };

              localTargetAllow = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                description = ''
                  Permissions granted for the {option}`services.syncoid.user` user
                  for local target datasets. See
                  <https://openzfs.github.io/openzfs-docs/man/8/zfs-allow.8.html>
                  for available permissions.
                  Make sure to include the `change-key` permission if you send raw encrypted datasets,
                  the `compression` permission if you send raw compressed datasets, and so on.
                  For remote target datasets you'll have to set your remote user permissions by yourself.
                '';
              };

              sendOptions = lib.mkOption {
                type = lib.types.separatedString " ";
                default = "";
                example = "Lc e";
                description = ''
                  Advanced options to pass to zfs send. Options are specified
                  without their leading dashes and separated by spaces.
                '';
              };

              recvOptions = lib.mkOption {
                type = lib.types.separatedString " ";
                default = "";
                example = "ux recordsize o compression=lz4";
                description = ''
                  Advanced options to pass to zfs recv. Options are specified
                  without their leading dashes and separated by spaces.
                '';
              };

              useCommonArgs = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = ''
                  Whether to add the configured common arguments to this command.
                '';
              };

              service = lib.mkOption {
                type = lib.types.attrs;
                default = { };
                description = ''
                  Systemd configuration specific to this syncoid service.
                '';
              };

              extraArgs = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                example = [ "--sshport 2222" ];
                description = "Extra syncoid arguments for this command.";
              };
            };
            config = {
              source = lib.mkDefault name;
              sshKey = lib.mkDefault cfg.sshKey;
              localSourceAllow = lib.mkDefault cfg.localSourceAllow;
              localTargetAllow = lib.mkDefault cfg.localTargetAllow;
            };
          }
        )
      );
      default = { };
      example = lib.literalExpression ''
        {
          "pool/test".target = "root@target:pool/test";
        }
      '';
      description = "Syncoid commands to run.";
    };
  };

  # Implementation

  config = lib.mkIf cfg.enable {
    users = {
      users = lib.mkIf (cfg.user == "syncoid") {
        syncoid = {
          group = cfg.group;
          isSystemUser = true;
          # For syncoid to be able to create /var/lib/syncoid/.ssh/
          # and to use custom ssh_config or known_hosts.
          home = "/var/lib/syncoid";
          createHome = false;
        };
      };
      groups = lib.mkIf (cfg.group == "syncoid") {
        syncoid = { };
      };
    };

    systemd.services = lib.mapAttrs' (
      name: c:
      lib.nameValuePair "syncoid-${escapeUnitName name}" (
        lib.mkMerge [
          {
            description = "Syncoid ZFS synchronization from ${c.source} to ${c.target}";
            after = [ "zfs.target" ];
            startAt = cfg.interval;
            # syncoid may need zpool to get feature@extensible_dataset
            path = [ "/run/booted-system/sw/bin/" ];
            serviceConfig = {
              ExecStartPre =
                (map (buildAllowCommand c.localSourceAllow) (localDatasetName c.source))
                ++ (map (buildAllowCommand c.localTargetAllow) (localDatasetName c.target));
              ExecStopPost =
                (map (buildUnallowCommand c.localSourceAllow) (localDatasetName c.source))
                ++ (map (buildUnallowCommand c.localTargetAllow) (localDatasetName c.target));
              ExecStart = lib.escapeShellArgs (
                [ "${cfg.package}/bin/syncoid" ]
                ++ lib.optionals c.useCommonArgs cfg.commonArgs
                ++ lib.optional c.recursive "-r"
                ++ lib.optionals (c.sshKey != null) [
                  "--sshkey"
                  c.sshKey
                ]
                ++ c.extraArgs
                ++ [
                  "--sendoptions"
                  c.sendOptions
                  "--recvoptions"
                  c.recvOptions
                  "--no-privilege-elevation"
                  c.source
                  c.target
                ]
              );
              User = cfg.user;
              Group = cfg.group;
              StateDirectory = [ "syncoid" ];
              StateDirectoryMode = "700";
              # Prevent SSH control sockets of different syncoid services from interfering
              PrivateTmp = true;
              # Permissive access to /proc because syncoid
              # calls ps(1) to detect ongoing `zfs receive`.
              ProcSubset = "all";
              ProtectProc = "default";

              # The following options are only for optimizing:
              # systemd-analyze security | grep syncoid-'*'
              AmbientCapabilities = "";
              CapabilityBoundingSet = "";
              DeviceAllow = [ "/dev/zfs" ];
              LockPersonality = true;
              MemoryDenyWriteExecute = true;
              NoNewPrivileges = true;
              PrivateDevices = true;
              PrivateMounts = true;
              PrivateNetwork = lib.mkDefault false;
              PrivateUsers = false; # Enabling this breaks on zfs-2.2.0
              ProtectClock = true;
              ProtectControlGroups = true;
              ProtectHome = true;
              ProtectHostname = true;
              ProtectKernelLogs = true;
              ProtectKernelModules = true;
              ProtectKernelTunables = true;
              ProtectSystem = "strict";
              RemoveIPC = true;
              RestrictAddressFamilies = [
                "AF_UNIX"
                "AF_INET"
                "AF_INET6"
              ];
              RestrictNamespaces = true;
              RestrictRealtime = true;
              RestrictSUIDSGID = true;
              RootDirectory = "/run/syncoid/${escapeUnitName name}";
              RootDirectoryStartOnly = true;
              BindPaths = [ "/dev/zfs" ];
              BindReadOnlyPaths = [
                builtins.storeDir
                "/etc"
                "/run"
                "/bin/sh"
              ];
              # Avoid useless mounting of RootDirectory= in the own RootDirectory= of ExecStart='s mount namespace.
              InaccessiblePaths = [ "-+/run/syncoid/${escapeUnitName name}" ];
              MountAPIVFS = true;
              # Create RootDirectory= in the host's mount namespace.
              RuntimeDirectory = [ "syncoid/${escapeUnitName name}" ];
              RuntimeDirectoryMode = "700";
              SystemCallFilter = [
                "@system-service"
                # Groups in @system-service which do not contain a syscall listed by:
                # perf stat -x, 2>perf.log -e 'syscalls:sys_enter_*' syncoid …
                # awk >perf.syscalls -F "," '$1 > 0 {sub("syscalls:sys_enter_","",$3); print $3}' perf.log
                # systemd-analyze syscall-filter | grep -v -e '#' | sed -e ':loop; /^[^ ]/N; s/\n //; t loop' | grep $(printf ' -e \\<%s\\>' $(cat perf.syscalls)) | cut -f 1 -d ' '
                "~@aio"
                "~@chown"
                "~@keyring"
                "~@memlock"
                "~@privileged"
                "~@resources"
                "~@setuid"
                "~@timer"
              ];
              SystemCallArchitectures = "native";
              # This is for BindPaths= and BindReadOnlyPaths=
              # to allow traversal of directories they create in RootDirectory=.
              UMask = "0066";
            };
          }
          cfg.service
          c.service
        ]
      )
    ) cfg.commands;
  };

  meta.maintainers = with lib.maintainers; [
    julm
    lopsided98
  ];
}
