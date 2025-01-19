{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.syncoid;

  # Extract local dataset names (so no datasets containing "@")
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
    lib.concatMapStrings (s: if builtins.isList s then "-" else s) (
      builtins.split "[^a-zA-Z0-9_.\\-]+" name
    );
in
{

  # Interface

  options.services.syncoid = {
    enable = lib.mkEnableOption "Syncoid ZFS synchronization service";

    package = lib.mkPackageOption pkgs "sanoid" { };

    interval = lib.mkOption {
      type = lib.types.str;
      default = "hourly";
      example = "*-*-* *:15:00";
      description = ''
        Run syncoid at this interval. The default is to run hourly.

        The format is described in
        {manpage}`systemd.time(7)`.
      '';
    };

    sshKey = lib.mkOption {
      type = with lib.types; nullOr (coercedTo path toString str);
      default = null;
      description = ''
        SSH private key file to use to login to the remote system.
        It can be overridden in individual commands.
        It is loaded using `LoadCredentialEncrypted=`
        when its path is prefixed by a credential name and colon,
        otherwise `LoadCredential=` is used.
        For more SSH tuning, you may use syncoid's `--sshoption`
        in {option}`services.syncoid.commonArgs`
        and/or in the `extraArgs` of a specific command.
      '';
    };

    localSourceAllow = lib.mkOption {
      type = with lib.types; listOf str;
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
        Permissions granted for the syncoid user for local source datasets.
        See <https://openzfs.github.io/openzfs-docs/man/8/zfs-allow.8.html>
        for available permissions.
      '';
    };

    localTargetAllow = lib.mkOption {
      type = with lib.types; listOf str;
      # Permission destroy is required to reset broken receive states (zfs receive -A),
      # which syncoid does when it fails to resume a receive state,
      # when the snapshot it refers to has been destroyed on the source.
      default = [
        "change-key"
        "compression"
        "create"
        "destroy"
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
        Permissions granted for the syncoid user for local target datasets.
        See <https://openzfs.github.io/openzfs-docs/man/8/zfs-allow.8.html>
        for available permissions.
        Make sure to include the `change-key` permission if you send raw encrypted datasets,
        the `compression` permission if you send raw compressed datasets, and so on.
        For remote target datasets you'll have to set your remote user permissions by yourself.
      '';
    };

    commonArgs = lib.mkOption {
      type = with lib.types; listOf str;
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

              useCommonArgs =
                lib.mkEnableOption ''
                  configured common arguments to this command
                ''
                // {
                  default = true;
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
    systemd.services = lib.mapAttrs' (
      name: c:
      let
        sshKeyCred = builtins.split ":" c.sshKey;
      in
      lib.nameValuePair "syncoid-${escapeUnitName name}" (
        lib.mkMerge [
          {
            description = "Syncoid ZFS synchronization from ${c.source} to ${c.target}";
            after = [ "zfs.target" ];
            startAt = cfg.interval;
            # Here we explicitly use the booted system to guarantee the stable API needed by ZFS.
            # Moreover syncoid may need zpool to get feature@extensible_dataset.
            path = [ "/run/booted-system/sw" ];
            # Prevents missing snapshots during DST changes
            environment.TZ = "UTC";
            # A custom LD_LIBRARY_PATH is needed to access in `getent passwd`
            # the systemd's entry about the DynamicUser=,
            # so that ssh won't fail with: "No user exists for uid $UID".
            environment.LD_LIBRARY_PATH = config.system.nssModules.path;
            serviceConfig =
              {
                ExecStartPre =
                  # Recursively remove any residual permissions
                  # given on local+descendant datasets (source, target or target's parent)
                  # to any currently unknown (hence unused) systemd dynamic users (UID/GID range 61184…65519),
                  # which happens when a crash has occurred
                  # during any previous run of a syncoid-*.service (not only this one).
                  map
                    (
                      dataset:
                      "+"
                      + pkgs.writeShellScript "zfs-unallow-unused-dynamic-users" ''
                        set -eu
                        zfs allow "$1" |
                        sed -ne 's/^\t\(user\|group\) (unknown: \([0-9]\+\)).*/\1 \2/p' |
                        {
                          declare -a uids
                          while read -r role id; do
                            if [ "$id" -ge 61184 ] && [ "$id" -le 65519 ]; then
                              case "$role" in
                                (user) uids+=("$id");;
                              esac
                            fi
                          done
                          zfs unallow -r -u "$(printf %s, "''${uids[@]}")" "$1"
                        }
                      ''
                      + " "
                      + lib.escapeShellArg dataset
                    )
                    (
                      localDatasetName c.source
                      ++ localDatasetName c.target
                      ++ map builtins.dirOf (localDatasetName c.target)
                    )
                  ++
                    # For a local source, allow the localSourceAllow ZFS permissions.
                    map (
                      dataset:
                      "+/run/booted-system/sw/bin/zfs allow $USER "
                      + lib.escapeShellArgs [
                        (lib.concatStringsSep "," c.localSourceAllow)
                        dataset
                      ]
                    ) (localDatasetName c.source)
                  ++
                    # For a local target, check if the dataset exists before delegating permissions,
                    # and if it doesn't exist, delegate it to the parent dataset.
                    # This should solve the case of provisioning new datasets.
                    map (
                      dataset:
                      "+"
                      + pkgs.writeShellScript "zfs-allow-target" ''
                        dataset="$1"
                        # Run a ZFS list on the dataset to check if it exists
                        zfs list "$dataset" >/dev/null 2>/dev/null ||
                          dataset="$(dirname "$dataset")"
                        zfs allow "$USER" ${lib.escapeShellArg (lib.concatStringsSep "," c.localTargetAllow)} "$dataset"
                      ''
                      + " "
                      + lib.escapeShellArg dataset
                    ) (localDatasetName c.target);
                ExecStopPost =
                  let
                    zfsUnallow = dataset: "+/run/booted-system/sw/bin/zfs unallow $USER " + lib.escapeShellArg dataset;
                  in
                  map zfsUnallow (localDatasetName c.source)
                  ++
                    # For a local target, unallow both the dataset and its parent,
                    # because at this stage we have no way of knowing if the allow command
                    # did execute on the parent dataset or not in the ExecStartPre=.
                    # We can't run the same if-then-else in the post hook
                    # since the dataset should have been created at this point.
                    lib.concatMap (dataset: [
                      (zfsUnallow dataset)
                      (zfsUnallow (builtins.dirOf dataset))
                    ]) (localDatasetName c.target);
                ExecStart = lib.escapeShellArgs (
                  [ "${cfg.package}/bin/syncoid" ]
                  ++ lib.optionals c.useCommonArgs cfg.commonArgs
                  ++ lib.optional c.recursive "--recursive"
                  ++ lib.optionals (c.sshKey != null) [
                    "--sshkey"
                    "\${CREDENTIALS_DIRECTORY}/${if lib.length sshKeyCred > 1 then lib.head sshKeyCred else "sshKey"}"
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
                DynamicUser = true;
                NFTSet = lib.optional config.networking.nftables.enable "user:inet:filter:nixos_syncoid_uids";
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
                ];
                SystemCallArchitectures = "native";
                # This is for BindPaths= and BindReadOnlyPaths=
                # to allow traversal of directories they create in RootDirectory=.
                UMask = "0066";
              }
              // (
                if lib.length sshKeyCred > 1 then
                  { LoadCredentialEncrypted = [ c.sshKey ]; }
                else
                  { LoadCredential = [ "sshKey:${c.sshKey}" ]; }
              );
          }
          cfg.service
          c.service
        ]
      )
    ) cfg.commands;

    networking.nftables.ruleset = lib.mkBefore ''
      table inet filter {
        # A set containing the dynamic UIDs of the syncoid services currently active
        set nixos_syncoid_uids { typeof meta skuid; }
      }
    '';
  };

  meta.maintainers = with lib.maintainers; [
    julm
    lopsided98
  ];
}
