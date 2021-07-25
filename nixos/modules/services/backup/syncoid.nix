{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.syncoid;

  # Extract the pool name of a local dataset (any dataset not containing "@")
  localPoolName = d: optionals (d != null) (
    let m = builtins.match "([^/@]+)[^@]*" d; in
    optionals (m != null) m);

  # Escape as required by: https://www.freedesktop.org/software/systemd/man/systemd.unit.html
  escapeUnitName = name:
    lib.concatMapStrings (s: if lib.isList s then "-" else s)
    (builtins.split "[^a-zA-Z0-9_.\\-]+" name);
in {

    # Interface

    options.services.syncoid = {
      enable = mkEnableOption "Syncoid ZFS synchronization service";

      interval = mkOption {
        type = types.str;
        default = "hourly";
        example = "*-*-* *:15:00";
        description = ''
          Run syncoid at this interval. The default is to run hourly.

          The format is described in
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>.
        '';
      };

      user = mkOption {
        type = types.str;
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

      group = mkOption {
        type = types.str;
        default = "syncoid";
        example = "backup";
        description = "The group for the service.";
      };

      sshKey = mkOption {
        type = types.nullOr types.path;
        # Prevent key from being copied to store
        apply = mapNullable toString;
        default = null;
        description = ''
          SSH private key file to use to login to the remote system. Can be
          overridden in individual commands.
        '';
      };

      commonArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--no-sync-snap" ];
        description = ''
          Arguments to add to every syncoid command, unless disabled for that
          command. See
          <link xlink:href="https://github.com/jimsalterjrs/sanoid/#syncoid-command-line-options"/>
          for available options.
        '';
      };

      service = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          Systemd configuration common to all syncoid services.
        '';
      };

      commands = mkOption {
        type = types.attrsOf (types.submodule ({ name, ... }: {
          options = {
            source = mkOption {
              type = types.str;
              example = "pool/dataset";
              description = ''
                Source ZFS dataset. Can be either local or remote. Defaults to
                the attribute name.
              '';
            };

            target = mkOption {
              type = types.str;
              example = "user@server:pool/dataset";
              description = ''
                Target ZFS dataset. Can be either local
                (<replaceable>pool/dataset</replaceable>) or remote
                (<replaceable>user@server:pool/dataset</replaceable>).
              '';
            };

            recursive = mkEnableOption ''the transfer of child datasets'';

            sshKey = mkOption {
              type = types.nullOr types.path;
              # Prevent key from being copied to store
              apply = mapNullable toString;
              description = ''
                SSH private key file to use to login to the remote system.
                Defaults to <option>services.syncoid.sshKey</option> option.
              '';
            };

            sendOptions = mkOption {
              type = types.separatedString " ";
              default = "";
              example = "Lc e";
              description = ''
                Advanced options to pass to zfs send. Options are specified
                without their leading dashes and separated by spaces.
              '';
            };

            recvOptions = mkOption {
              type = types.separatedString " ";
              default = "";
              example = "ux recordsize o compression=lz4";
              description = ''
                Advanced options to pass to zfs recv. Options are specified
                without their leading dashes and separated by spaces.
              '';
            };

            useCommonArgs = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether to add the configured common arguments to this command.
              '';
            };

            service = mkOption {
              type = types.attrs;
              default = {};
              description = ''
                Systemd configuration specific to this syncoid service.
              '';
            };

            extraArgs = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "--sshport 2222" ];
              description = "Extra syncoid arguments for this command.";
            };
          };
          config = {
            source = mkDefault name;
            sshKey = mkDefault cfg.sshKey;
          };
        }));
        default = {};
        example = literalExample ''
          {
            "pool/test".target = "root@target:pool/test";
          }
        '';
        description = "Syncoid commands to run.";
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
          syncoid = {};
        };
      };

      systemd.services = mapAttrs' (name: c:
        nameValuePair "syncoid-${escapeUnitName name}" (mkMerge [
          { description = "Syncoid ZFS synchronization from ${c.source} to ${c.target}";
            after = [ "zfs.target" ];
            startAt = cfg.interval;
            # syncoid may need zpool to get feature@extensible_dataset
            path = [ "/run/booted-system/sw/bin/" ];
            serviceConfig = {
              ExecStartPre =
                map (pool: lib.escapeShellArgs [
                  "+/run/booted-system/sw/bin/zfs" "allow"
                  cfg.user "bookmark,hold,send,snapshot,destroy" pool
                  # Permissions snapshot and destroy are in case --no-sync-snap is not used
                ]) (localPoolName c.source) ++
                map (pool: lib.escapeShellArgs [
                  "+/run/booted-system/sw/bin/zfs" "allow"
                  cfg.user "create,mount,receive,rollback" pool
                ]) (localPoolName c.target);
              ExecStart = lib.escapeShellArgs ([ "${pkgs.sanoid}/bin/syncoid" ]
                ++ optionals c.useCommonArgs cfg.commonArgs
                ++ optional c.recursive "-r"
                ++ optionals (c.sshKey != null) [ "--sshkey" c.sshKey ]
                ++ c.extraArgs
                ++ [ "--sendoptions" c.sendOptions
                     "--recvoptions" c.recvOptions
                     "--no-privilege-elevation"
                     c.source c.target
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
              DeviceAllow = ["/dev/zfs"];
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
              BindReadOnlyPaths = [ builtins.storeDir "/etc" "/run" "/bin/sh" ];
              # Avoid useless mounting of RootDirectory= in the own RootDirectory= of ExecStart='s mount namespace.
              InaccessiblePaths = ["-+/run/syncoid/${escapeUnitName name}"];
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
                "~@aio" "~@chown" "~@keyring" "~@memlock" "~@privileged"
                "~@resources" "~@setuid" "~@sync" "~@timer"
              ];
              SystemCallArchitectures = "native";
              # This is for BindPaths= and BindReadOnlyPaths=
              # to allow traversal of directories they create in RootDirectory=.
              UMask = "0066";
            };
          }
          cfg.service
          c.service
        ])) cfg.commands;
    };

    meta.maintainers = with maintainers; [ julm lopsided98 ];
  }
