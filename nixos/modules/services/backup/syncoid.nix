{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.syncoid;

  # Extract local dasaset names (so no datasets containing "@")
  localDatasetName = d: optionals (d != null) (
    let m = builtins.match "([^/@]+[^@]*)" d; in
    optionals (m != null) m
  );

  # Escape as required by: https://www.freedesktop.org/software/systemd/man/systemd.unit.html
  escapeUnitName = name:
    lib.concatMapStrings (s: if lib.isList s then "-" else s)
      (builtins.split "[^a-zA-Z0-9_.\\-]+" name);

  # Function to build "zfs allow" commands for the filesystems we've delegated
  # permissions to. It also checks if the target dataset exists before
  # delegating permissions, if it doesn't exist we delegate it to the parent
  # dataset (if it exists). This should solve the case of provisoning new
  # datasets.
  buildAllowCommand = permissions: dataset: (
    "-+${pkgs.writeShellScript "zfs-allow-${dataset}" ''
      # Here we explicitly use the booted system to guarantee the stable API needed by ZFS

      # Run a ZFS list on the dataset to check if it exists
      if ${lib.escapeShellArgs [
        "/run/booted-system/sw/bin/zfs"
        "list"
        dataset
      ]} 2> /dev/null; then
        ${lib.escapeShellArgs [
          "/run/booted-system/sw/bin/zfs"
          "allow"
          cfg.user
          (concatStringsSep "," permissions)
          dataset
        ]}
      ${lib.optionalString ((builtins.dirOf dataset) != ".") ''
        else
          ${lib.escapeShellArgs [
            "/run/booted-system/sw/bin/zfs"
            "allow"
            cfg.user
            (concatStringsSep "," permissions)
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
  buildUnallowCommand = permissions: dataset: (
    "-+${pkgs.writeShellScript "zfs-unallow-${dataset}" ''
      # Here we explicitly use the booted system to guarantee the stable API needed by ZFS
      ${lib.escapeShellArgs [
        "/run/booted-system/sw/bin/zfs"
        "unallow"
        cfg.user
        (concatStringsSep "," permissions)
        dataset
      ]}
      ${lib.optionalString ((builtins.dirOf dataset) != ".") (lib.escapeShellArgs [
        "/run/booted-system/sw/bin/zfs"
        "unallow"
        cfg.user
        (concatStringsSep "," permissions)
        # Remove the last part of the path
        (builtins.dirOf dataset)
      ])}
    ''}"
  );
in
{

  # Interface

  options.services.syncoid = {
    enable = mkEnableOption (lib.mdDoc "Syncoid ZFS synchronization service");

    package = lib.mkPackageOption pkgs "sanoid" {};

    interval = mkOption {
      type = types.str;
      default = "hourly";
      example = "*-*-* *:15:00";
      description = lib.mdDoc ''
        Run syncoid at this interval. The default is to run hourly.

        The format is described in
        {manpage}`systemd.time(7)`.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "syncoid";
      example = "backup";
      description = lib.mdDoc ''
        The user for the service. ZFS privilege delegation will be
        automatically configured for any local pools used by syncoid if this
        option is set to a user other than root. The user will be given the
        "hold" and "send" privileges on any pool that has datasets being sent
        and the "create", "mount", "receive", and "rollback" privileges on
        any pool that has datasets being received.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "syncoid";
      example = "backup";
      description = lib.mdDoc "The group for the service.";
    };

    sshKey = mkOption {
      type = with types; nullOr (coercedTo path toString str);
      default = null;
      description = lib.mdDoc ''
        SSH private key file to use to login to the remote system. Can be
        overridden in individual commands.
      '';
    };

    localSourceAllow = mkOption {
      type = types.listOf types.str;
      # Permissions snapshot and destroy are in case --no-sync-snap is not used
      default = [ "bookmark" "hold" "send" "snapshot" "destroy" ];
      description = lib.mdDoc ''
        Permissions granted for the {option}`services.syncoid.user` user
        for local source datasets. See
        <https://openzfs.github.io/openzfs-docs/man/8/zfs-allow.8.html>
        for available permissions.
      '';
    };

    localTargetAllow = mkOption {
      type = types.listOf types.str;
      default = [ "change-key" "compression" "create" "mount" "mountpoint" "receive" "rollback" ];
      example = [ "create" "mount" "receive" "rollback" ];
      description = lib.mdDoc ''
        Permissions granted for the {option}`services.syncoid.user` user
        for local target datasets. See
        <https://openzfs.github.io/openzfs-docs/man/8/zfs-allow.8.html>
        for available permissions.
        Make sure to include the `change-key` permission if you send raw encrypted datasets,
        the `compression` permission if you send raw compressed datasets, and so on.
        For remote target datasets you'll have to set your remote user permissions by yourself.
      '';
    };

    commonArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--no-sync-snap" ];
      description = lib.mdDoc ''
        Arguments to add to every syncoid command, unless disabled for that
        command. See
        <https://github.com/jimsalterjrs/sanoid/#syncoid-command-line-options>
        for available options.
      '';
    };

    service = mkOption {
      type = types.attrs;
      default = { };
      description = lib.mdDoc ''
        Systemd configuration common to all syncoid services.
      '';
    };

    commands = mkOption {
      type = types.attrsOf (types.submodule ({ name, ... }: {
        options = {
          source = mkOption {
            type = types.str;
            example = "pool/dataset";
            description = lib.mdDoc ''
              Source ZFS dataset. Can be either local or remote. Defaults to
              the attribute name.
            '';
          };

          target = mkOption {
            type = types.str;
            example = "user@server:pool/dataset";
            description = lib.mdDoc ''
              Target ZFS dataset. Can be either local
              («pool/dataset») or remote
              («user@server:pool/dataset»).
            '';
          };

          recursive = mkEnableOption (lib.mdDoc ''the transfer of child datasets'');

          sshKey = mkOption {
            type = with types; nullOr (coercedTo path toString str);
            description = lib.mdDoc ''
              SSH private key file to use to login to the remote system.
              Defaults to {option}`services.syncoid.sshKey` option.
            '';
          };

          localSourceAllow = mkOption {
            type = types.listOf types.str;
            description = lib.mdDoc ''
              Permissions granted for the {option}`services.syncoid.user` user
              for local source datasets. See
              <https://openzfs.github.io/openzfs-docs/man/8/zfs-allow.8.html>
              for available permissions.
              Defaults to {option}`services.syncoid.localSourceAllow` option.
            '';
          };

          localTargetAllow = mkOption {
            type = types.listOf types.str;
            description = lib.mdDoc ''
              Permissions granted for the {option}`services.syncoid.user` user
              for local target datasets. See
              <https://openzfs.github.io/openzfs-docs/man/8/zfs-allow.8.html>
              for available permissions.
              Make sure to include the `change-key` permission if you send raw encrypted datasets,
              the `compression` permission if you send raw compressed datasets, and so on.
              For remote target datasets you'll have to set your remote user permissions by yourself.
            '';
          };

          sendOptions = mkOption {
            type = types.separatedString " ";
            default = "";
            example = "Lc e";
            description = lib.mdDoc ''
              Advanced options to pass to zfs send. Options are specified
              without their leading dashes and separated by spaces.
            '';
          };

          recvOptions = mkOption {
            type = types.separatedString " ";
            default = "";
            example = "ux recordsize o compression=lz4";
            description = lib.mdDoc ''
              Advanced options to pass to zfs recv. Options are specified
              without their leading dashes and separated by spaces.
            '';
          };

          useCommonArgs = mkOption {
            type = types.bool;
            default = true;
            description = lib.mdDoc ''
              Whether to add the configured common arguments to this command.
            '';
          };

          service = mkOption {
            type = types.attrs;
            default = { };
            description = lib.mdDoc ''
              Systemd configuration specific to this syncoid service.
            '';
          };

          extraArgs = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "--sshport 2222" ];
            description = lib.mdDoc "Extra syncoid arguments for this command.";
          };
        };
        config = {
          source = mkDefault name;
          sshKey = mkDefault cfg.sshKey;
          localSourceAllow = mkDefault cfg.localSourceAllow;
          localTargetAllow = mkDefault cfg.localTargetAllow;
        };
      }));
      default = { };
      example = literalExpression ''
        {
          "pool/test".target = "root@target:pool/test";
        }
      '';
      description = lib.mdDoc "Syncoid commands to run.";
    };
  };

  # Implementation

  config = mkIf cfg.enable {
    users = {
      users = mkIf (cfg.user == "syncoid") {
        syncoid = {
          group = cfg.group;
          isSystemUser = true;
          # For syncoid to be able to create /var/lib/syncoid/.ssh/
          # and to use custom ssh_config or known_hosts.
          home = "/var/lib/syncoid";
          createHome = false;
        };
      };
      groups = mkIf (cfg.group == "syncoid") {
        syncoid = { };
      };
    };

    systemd.services = mapAttrs'
      (name: c:
        nameValuePair "syncoid-${escapeUnitName name}" (mkMerge [
          {
            description = "Syncoid ZFS synchronization from ${c.source} to ${c.target}";
            after = [ "zfs.target" ];
            startAt = cfg.interval;
            # syncoid may need zpool to get feature@extensible_dataset
            path = [ "/run/booted-system/sw/bin/" ];
            serviceConfig = {
              ExecStartPre =
                (map (buildAllowCommand c.localSourceAllow) (localDatasetName c.source)) ++
                (map (buildAllowCommand c.localTargetAllow) (localDatasetName c.target));
              ExecStopPost =
                (map (buildUnallowCommand c.localSourceAllow) (localDatasetName c.source)) ++
                (map (buildUnallowCommand c.localTargetAllow) (localDatasetName c.target));
              ExecStart = lib.escapeShellArgs ([ "${cfg.package}/bin/syncoid" ]
                ++ optionals c.useCommonArgs cfg.commonArgs
                ++ optional c.recursive "-r"
                ++ optionals (c.sshKey != null) [ "--sshkey" c.sshKey ]
                ++ c.extraArgs
                ++ [
                "--sendoptions"
                c.sendOptions
                "--recvoptions"
                c.recvOptions
                "--no-privilege-elevation"
                c.source
                c.target
              ]);
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
              PrivateNetwork = mkDefault false;
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
              RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
              RestrictNamespaces = true;
              RestrictRealtime = true;
              RestrictSUIDSGID = true;
              RootDirectory = "/run/syncoid/${escapeUnitName name}";
              RootDirectoryStartOnly = true;
              BindPaths = [ "/dev/zfs" ];
              BindReadOnlyPaths = [ builtins.storeDir "/etc" "/run" "/bin/sh" ];
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
        ]))
      cfg.commands;
  };

  meta.maintainers = with maintainers; [ julm lopsided98 ];
}
