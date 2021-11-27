{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.syncoid;
  inherit (config.networking) nftables;

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
      set -eux
      # Run a ZFS list on the dataset to check if it exists
      if zfs list ${lib.escapeShellArg dataset} >/dev/null 2>/dev/null; then
        zfs allow "$USER" ${lib.escapeShellArgs [
          (concatStringsSep "," permissions)
          dataset
        ]}
      ${lib.optionalString ((builtins.dirOf dataset) != ".") ''
        else
          zfs allow "$USER" ${lib.escapeShellArgs [
            (concatStringsSep "," permissions)
            # Remove the last part of the path
            (builtins.dirOf dataset)
          ]}
      ''}
      fi
    ''}"
  );

  # Function to build "zfs unallow" commands for the filesystems we've
  # delegated permissions to. Here we unallow both the target and
  # the parent dataset because at this stage we have no way of
  # knowing if the allow command did execute on the parent dataset or
  # not in the pre-hook. We can't run the same if-then-else in the post hook
  # since the dataset should have been created at this point.
  buildUnallowCommand = dataset: (
    "-+${pkgs.writeShellScript "zfs-unallow-${dataset}" ''
      set -eux
      zfs unallow "$USER" ${lib.escapeShellArg dataset}
      ${lib.optionalString ((builtins.dirOf dataset) != ".") ''
        zfs unallow "$USER" ${lib.escapeShellArg (builtins.dirOf dataset)}
      ''}
    ''}"
  );
in
{

  # Interface

  options.services.syncoid = {
    enable = mkEnableOption (lib.mdDoc "Syncoid ZFS synchronization service");

    package = lib.mkPackageOptionMD pkgs "sanoid" {};

    nftables.enable = mkEnableOption (lib.mdDoc ''
      nftables integration.

      This can be used like so (assuming `output-net`
      is being called by the output chain):
      ```
      networking.nftables.ruleset = "table inet filter { chain output-net { skuid @nixos-syncoid-uids meta l4proto tcp accept } }";
      ```
    '');

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

    sshKey = mkOption {
      type = types.nullOr types.path;
      # Prevent key from being copied to store
      apply = mapNullable toString;
      default = null;
      description = lib.mdDoc ''
        SSH private key file to use to login to the remote system. Can be
        overridden in individual commands.
        For more SSH tuning, you may use syncoid's `--sshoption`
        in {option}`services.syncoid.commonArgs`
        and/or in the `extraArgs` of a specific command.
      '';
    };

    localSourceAllow = mkOption {
      type = types.listOf types.str;
      # Permissions snapshot and destroy are in case --no-sync-snap is not used
      default = [ "bookmark" "hold" "send" "snapshot" "destroy" ];
      description = lib.mdDoc ''
        Permissions granted for the syncoid user for local source datasets.
        See <https://openzfs.github.io/openzfs-docs/man/8/zfs-allow.8.html>
        for available permissions.
      '';
    };

    localTargetAllow = mkOption {
      type = types.listOf types.str;
      default = [ "change-key" "compression" "create" "destroy" "mount" "mountpoint" "receive" "rollback" ];
      example = [ "create" "mount" "receive" "rollback" ];
      description = lib.mdDoc ''
        Permissions granted for the syncoid user for local target datasets.
        See <https://openzfs.github.io/openzfs-docs/man/8/zfs-allow.8.html>
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
            type = types.nullOr types.path;
            # Prevent key from being copied to store
            apply = mapNullable toString;
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

          useCommonArgs = mkEnableOption (lib.mdDoc ''
            configured common arguments to this command
          '') // { default = true; };

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
    assertions = [
      { assertion = cfg.nftables.enable -> config.networking.nftables.enable;
        message = "config.networking.nftables.enable must be set when config.services.syncoid.nftables.enable is set";
      }
    ];

    systemd.services = mapAttrs'
      (name: c:
        nameValuePair "syncoid-${escapeUnitName name}" (mkMerge [
          {
            description = "Syncoid ZFS synchronization from ${c.source} to ${c.target}";
            after = [ "zfs.target" ];
            startAt = cfg.interval;
            # Here we explicitly use the booted system to guarantee the stable API needed by ZFS.
            # Moreover syncoid may need zpool to get feature@extensible_dataset.
            path = [ "/run/booted-system/sw" ];
            serviceConfig = {
              ExecStartPre =
                (map (buildAllowCommand c.localSourceAllow) (localDatasetName c.source)) ++
                (map (buildAllowCommand c.localTargetAllow) (localDatasetName c.target)) ++
                optional cfg.nftables.enable
                  "+${pkgs.nftables}/bin/nft add element inet filter nixos-syncoid-uids { $USER }";
              ExecStopPost =
                (map buildUnallowCommand (localDatasetName c.source)) ++
                (map buildUnallowCommand (localDatasetName c.target)) ++
                optional cfg.nftables.enable
                  "+${pkgs.nftables}/bin/nft delete element inet filter nixos-syncoid-uids { $USER }";
              ExecStart = lib.escapeShellArgs ([ "${cfg.package}/bin/syncoid" ]
                ++ optionals c.useCommonArgs cfg.commonArgs
                ++ optional c.recursive "--recursive"
                ++ optionals (c.sshKey != null) [ "--sshkey" "\${CREDENTIALS_DIRECTORY}/ssh-key" ]
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
              DynamicUser = true;
              LoadCredential = [ "ssh-key:${c.sshKey}" ];
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
              PrivateUsers = true;
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
              BindReadOnlyPaths = [ builtins.storeDir "/etc" "/run" "/bin/sh"
                # A custom LD_LIBRARY_PATH is needed to access in `getent passwd`
                # the systemd's entry about the DynamicUser=,
                # so that ssh won't fail with: "No user exists for uid $UID".
                # Unfortunately, Bash is incompatible with libnss_systemd.so:
                # https://www.mail-archive.com/bug-bash@gnu.org/msg24306.html
                # Hence the wrapping of ssh is done here as a mounted path,
                # because Nixpkgs' wrapping of syncoid enforces the use
                # of the ${pkgs.openssh}/bin/ssh path.
                # This problem does not arise on NixOS systems where stdenv.hostPlatform.libc == "musl",
                # because then Bash is built with --without-bash-malloc
                ("${pkgs.writeShellScript "ssh-with-support-for-DynamicUser" ''
                  export LD_LIBRARY_PATH="${config.system.nssModules.path}"
                  exec -a ${pkgs.openssh}/bin/ssh /bin/ssh "$@"
                ''}:${pkgs.openssh}/bin/ssh")
                "${pkgs.openssh}/bin/ssh:/bin/ssh"
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
            };
          }
          cfg.service
          c.service
        ]))
      cfg.commands;

    networking.nftables.ruleset = optionalString cfg.nftables.enable (mkBefore ''
      table inet filter {
        # A set containing the dynamic UIDs of the syncoid services currently active
        set nixos-syncoid-uids { type uid; }
      }
    '');
  };

  meta.maintainers = with maintainers; [ julm lopsided98 ];
}
