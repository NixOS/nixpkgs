{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    all
    mkEnableOption
    mkOption
    literalExpression
    types
    mkMerge
    mkIf
    optionals
    mkDefault
    filterAttrs
    mapAttrsToList
    foldl'
    getExe
    escape
    versionAtLeast
    versionOlder
    isInt
    filter
    concatLists
    ;

  inInitrd = config.boot.initrd.supportedFilesystems.btrfs or false;
  inSystem = config.boot.supportedFilesystems.btrfs or false;

  cfgBalance = config.services.btrfs.autoBalance;
  cfgScrub = config.services.btrfs.autoScrub;

  enableAutoBalance = cfgBalance.enable;
  enableAutoScrub = cfgScrub.enable;
  enableBtrfs = inInitrd || inSystem || enableAutoScrub || enableAutoBalance;

  usageType =
    let
      inherit (types)
        either
        nullOr
        ints
        strMatching
        ;
      percentageType = ints.between 0 100;
      percentRegex = "([0-9]?[0-9]|100)";
      fullRange = "${percentRegex}\\.\\.${percentRegex}";
      implicitMinimum = "\\.\\.${percentRegex}";
      implicitMaximum = "${percentRegex}\\.\\.";
      rangeType = strMatching "${fullRange}|${implicitMinimum}|${implicitMaximum}";
    in
    nullOr (either percentageType rangeType);

  limitType =
    let
      inherit (types)
        either
        nullOr
        ints
        strMatching
        ;
      chunksRegex = "([0-9]+)";
      fullRange = "${chunksRegex}\\.\\.${chunksRegex}";
      implicitMinimum = "\\.\\.${chunksRegex}";
      implicitMaximum = "${chunksRegex}\\.\\.";
      rangeType = strMatching "${fullRange}|${implicitMinimum}|${implicitMaximum}";
    in
    nullOr (either ints.unsigned rangeType);

  # This will remove duplicated units from either having a filesystem mounted multiple
  # time, or additionally mounted subvolumes, as well as having a filesystem span
  # multiple devices (provided the same device is used to mount said filesystem).
  defaultFilesystems =
    let
      isDeviceInList = list: device: filter (e: e.device == device) list != [ ];

      uniqueDeviceList = foldl' (acc: e: if isDeviceInList acc e.device then acc else acc ++ [ e ]) [ ];
    in
    map (e: e.mountPoint) (
      uniqueDeviceList (
        mapAttrsToList (name: fs: {
          mountPoint = fs.mountPoint;
          device = fs.device;
        }) (filterAttrs (name: fs: fs.fsType == "btrfs") config.fileSystems)
      )
    );
in

{
  meta.maintainers = with lib.maintainers; [
    Deric-W
  ];

  options = {
    services.btrfs.autoBalance = {
      enable = mkEnableOption "regular btrfs balance";

      fileSystems = mkOption {
        type = types.listOf types.path;
        example = [ "/" ];
        description = ''
          List of paths to btrfs filesystems to regularly call {command}`btrfs balance` on.
          Defaults to all mount points with btrfs filesystems.
          Note that if you have filesystems that span multiple devices (e.g. RAID), you should
          take care to use the same device for any given mount point and let btrfs take care
          of automatically mounting the rest, in order to avoid balancing the same data multiple
          times.
        '';
      };

      interval = mkOption {
        default = "weekly";
        type = types.str;
        example = "monthly";
        description = ''
          Systemd calendar expression for when to balance btrfs filesystems.
          The default period is once a week.
          See
          {manpage}`systemd.time(7)`
          for more information on the syntax.
        '';
      };

      dusage = mkOption {
        default = if versionAtLeast config.boot.kernelPackages.kernel.version "3.3" then 10 else null;
        defaultText = literalExpression ''
          if lib.versionAtLeast config.boot.kernelPackages.kernel.version "3.3" then 10 else null
        '';
        type = usageType;
        example = "..10";
        description = ''
          Relocate data block groups with matching usage.
          Single numbers N are equivalent to "at most N percent used" (range `..N`),
          with custom ranges being supported.

          Lower values (or smaller ranges) mean cheaper, faster balances that only touch
          near-empty chunks; higher values (or larger ranges) reclaim more space but take
          longer.
        '';
      };

      musage = mkOption {
        default = null;
        type = usageType;
        example = "..5";
        description = ''
          Relocate metadata block groups with matching usage.
          Single numbers N are equivalent to "at most N percent used" (range `..N`),
          with custom ranges being supported.

          Lower values (or smaller ranges) mean cheaper, faster balances that only touch
          near-empty chunks; higher values (or larger ranges) reclaim more space but take
          longer.

          CAUTION: Balancing metadata block groups increases the risk of the filesystem
          becoming read-only if new metadata block groups need to be allocated and no
          free space is available.
        '';
      };

      dlimit = mkOption {
        default = null;
        type = limitType;
        example = "..10";
        description = ''
          Relocate data block groups, limiting the number of processed block groups.
          Single numbers N are equivalent to "at most N chunks" (range `..N`),
          with custom ranges being supported.

          This can be used to limit the amount of work done by a single balance run.
        '';
      };

      mlimit = mkOption {
        default = null;
        type = limitType;
        example = "..10";
        description = ''
          Relocate metadata block groups, limiting the number of processed block groups.
          Single numbers N are equivalent to "at most N chunks" (range `..N`),
          with custom ranges being supported.

          This can be used to limit the amount of work done by a single balance run.

          CAUTION: Balancing metadata block groups increases the risk of the filesystem
          becoming read-only if new metadata block groups need to be allocated and no
          free space is available.
        '';
      };
    };

    services.btrfs.autoScrub = {
      enable = mkEnableOption "regular btrfs scrub";

      fileSystems = mkOption {
        type = types.listOf types.path;
        example = [ "/" ];
        description = ''
          List of paths to btrfs filesystems to regularly call {command}`btrfs scrub` on.
          Defaults to all mount points with btrfs filesystems.
          Note that if you have filesystems that span multiple devices (e.g. RAID), you should
          take care to use the same device for any given mount point and let btrfs take care
          of automatically mounting the rest, in order to avoid scrubbing the same data multiple times.
        '';
      };

      interval = mkOption {
        default = "monthly";
        type = types.str;
        example = "weekly";
        description = ''
          Systemd calendar expression for when to scrub btrfs filesystems.
          The recommended period is a month but could be less
          ({manpage}`btrfs-scrub(8)`).
          See
          {manpage}`systemd.time(7)`
          for more information on the syntax.
        '';
      };

      limit = mkOption {
        default = null;
        type = types.nullOr (types.strMatching "[0-9]+[KMGT]?");
        example = "100M";
        description = ''
          The scrub throughput limit applied on all scrubbed filesystems.
          The value is bytes per second, and accepts the usual KMGT prefixes.
        '';
      };

    };
  };

  config = mkMerge [
    (mkIf enableBtrfs {
      system.fsPackages = [ pkgs.btrfs-progs ];
    })

    (mkIf inInitrd {
      boot.initrd.kernelModules = [ "btrfs" ];
      boot.initrd.availableKernelModules = (
        mkIf (config.boot.kernelPackages.kernel.kernelOlder "7.0") (
          [
            "crc32c"
          ]
          ++ optionals (config.boot.kernelPackages.kernel.kernelAtLeast "5.5") [
            # The canonical names of these modules are not very stable, so use the algorithm names that the btrfs module expects.
            # See: https://github.com/torvalds/linux/blob/v6.19-rc1/fs/btrfs/super.c#L2705-L2708
            "xxhash64"
            "sha256" # Should be baked into our kernel, just to be sure
            "blake2b-256"
          ]
        )
      );

      boot.initrd.extraUtilsCommands = mkIf (!config.boot.initrd.systemd.enable) ''
        copy_bin_and_libs ${pkgs.btrfs-progs}/bin/btrfs
        ln -sv btrfs $out/bin/btrfsck
        ln -sv btrfsck $out/bin/fsck.btrfs
      '';

      boot.initrd.extraUtilsCommandsTest = mkIf (!config.boot.initrd.systemd.enable) ''
        $out/bin/btrfs --version
      '';

      boot.initrd.postDeviceCommands = mkIf (!config.boot.initrd.systemd.enable) ''
        btrfs device scan
      '';

      boot.initrd.systemd.initrdBin = [ pkgs.btrfs-progs ];
    })

    (mkIf enableAutoBalance {
      assertions =
        let
          mkFilterAssertion = option: {
            assertion =
              versionOlder config.boot.kernelPackages.kernel.version "3.3" -> cfgBalance.${option} == null;
            message = ''
              Enabling 'services.btrfs.autoBalance.${option}` requires at least a linux 3.3 kernel.
            '';
          };
          mkRangeAssertion = option: {
            assertion =
              versionOlder config.boot.kernelPackages.kernel.version "4.4"
              -> (isInt cfgBalance.${option} || cfgBalance.${option} == null);
            message = ''
              Kernels prior to 4.4 do not accept ranges for the option 'services.btrfs.autoBalance.${option}'.
            '';
          };
          filterOptions = [
            "dusage"
            "musage"
            "dlimit"
            "mlimit"
          ];
        in
        [
          {
            assertion = cfgBalance.enable -> (cfgBalance.fileSystems != [ ]);
            message = ''
              If 'services.btrfs.autoBalance' is enabled, you need to have at least one
              btrfs file system mounted via 'fileSystems' or specify a list manually
              in 'services.btrfs.autoBalance.fileSystems'.
            '';
          }
        ]
        ++ map mkFilterAssertion filterOptions
        ++ map mkRangeAssertion filterOptions;

      warnings =
        optionals
          (all (option: cfgBalance.${option} == null) [
            "dusage"
            "musage"
            "dlimit"
            "mlimit"
          ])
          [
            ''
              Balancing btrfs filesystems without any filters (possible by explicitly setting all
              filter options of `services.btrfs.autoBalance` to `null`) will result in basically
              all data in the filesystem being moved, which, depending of the filesystem size,
              can take very long.
            ''
          ];

      services.btrfs.autoBalance.fileSystems = mkDefault defaultFilesystems;

      systemd.services."btrfs-balance@" = {
        description = "btrfs balance on %f";
        documentation = [ "man:btrfs-balance(8)" ];
        # balance prevents suspend2ram or proper shutdown
        conflicts = [
          "shutdown.target"
          "sleep.target"
        ];
        before = [
          "shutdown.target"
          "sleep.target"
        ];

        unitConfig.RequiresMountsFor = "%f";

        serviceConfig =
          let
            btrfsCmd = getExe pkgs.btrfs-progs;
            btrfsCancelCmd =
              pkgs.writers.writePython3 "btrfs-balance-maybe-cancel"
                {
                  flakeIgnore = [
                    # `btrfsCmd` may exceed 80-character line length for some platforms
                    "E501"
                  ];
                }
                ''
                  import subprocess
                  import sys

                  btrfs = "${escape [ "\"" "\\" ] btrfsCmd}"
                  result = subprocess.run(
                      [btrfs, "balance", "cancel"] + sys.argv[1:],
                      stderr=subprocess.PIPE,
                      check=False,
                      shell=False
                  )

                  # ignore errors if there was no running balance to cancel
                  if result.returncode == 2:
                      sys.exit(0)

                  sys.stderr.buffer.write(result.stderr)
                  sys.exit(result.returncode)
                '';
            additionalBalanceArgs =
              let
                mkArg =
                  option: optionals (cfgBalance.${option} != null) [ "-${option}=${toString cfgBalance.${option}}" ];
              in
              concatLists (
                map mkArg [
                  "dusage"
                  "musage"
                  "dlimit"
                  "mlimit"
                ]
              );
          in
          {
            # simple and not oneshot, otherwise ExecStop is not used
            Type = "simple";
            Nice = 19;
            CPUSchedulingPolicy = "idle";
            IOSchedulingClass = "idle";
            ExecStart = "${
              utils.escapeSystemdExecArgs (
                [
                  btrfsCmd
                  "balance"
                  "start"
                ]
                ++ additionalBalanceArgs
              )
            } %f";
            # if the service is stopped before balance end, cancel it
            ExecStop = "${utils.escapeSystemdExecArg btrfsCancelCmd} %f";
          };
      };

      systemd.timers."btrfs-balance@" = {
        description = "Regular btrfs balance on %f";
        documentation = [ "man:btrfs-balance(8)" ];

        timerConfig = {
          OnCalendar = cfgBalance.interval;
          AccuracySec = "1d";
          Persistent = true;
        };
      };

      systemd.targets.timers.wants = map (
        fs: "btrfs-balance@${utils.escapeSystemdPath fs}.timer"
      ) cfgBalance.fileSystems;
    })

    (mkIf enableAutoScrub {
      assertions = [
        {
          assertion = cfgScrub.enable -> (cfgScrub.fileSystems != [ ]);
          message = ''
            If 'services.btrfs.autoScrub' is enabled, you need to have at least one
            btrfs file system mounted via 'fileSystems' or specify a list manually
            in 'services.btrfs.autoScrub.fileSystems'.
          '';
        }
      ];

      services.btrfs.autoScrub.fileSystems = mkDefault defaultFilesystems;

      systemd.services."btrfs-scrub@" = {
        description = "btrfs scrub on %f";
        documentation = [ "man:btrfs-scrub(8)" ];
        # scrub prevents suspend2ram or proper shutdown on linux < 6.19
        conflicts = optionals (versionOlder config.boot.kernelPackages.kernel.version "6.19") [
          "shutdown.target"
          "sleep.target"
        ];
        before = optionals (versionOlder config.boot.kernelPackages.kernel.version "6.19") [
          "shutdown.target"
          "sleep.target"
        ];

        # prevent problems with MemoryDenyWriteExecute
        environment.PYTHON_JIT = "0";

        unitConfig.RequiresMountsFor = "%f";

        serviceConfig =
          let
            btrfsCmd = getExe pkgs.btrfs-progs;
            btrfsCancelCmd =
              pkgs.writers.writePython3 "btrfs-scrub-maybe-cancel"
                {
                  flakeIgnore = [
                    # `btrfsCmd` may exceed 80-character line length for some platforms
                    "E501"
                  ];
                }
                ''
                  import subprocess
                  import sys

                  btrfs = "${escape [ "\"" "\\" ] btrfsCmd}"
                  result = subprocess.run(
                      [btrfs, "scrub", "cancel"] + sys.argv[1:],
                      stderr=subprocess.PIPE,
                      check=False,
                      shell=False
                  )

                  # ignore errors if there was no running scrub to cancel
                  if result.returncode == 2:
                      sys.exit(0)

                  sys.stderr.buffer.write(result.stderr)
                  sys.exit(result.returncode)
                '';
            additionalScrubArgs = optionals (cfgScrub.limit != null) [
              "--limit"
              cfgScrub.limit
            ];
          in
          {
            # simple and not oneshot, otherwise ExecStop is not used
            Type = "simple";
            Nice = 19;
            CPUSchedulingPolicy = "idle";
            IOSchedulingClass = "idle";
            ExecStart = "${
              utils.escapeSystemdExecArgs (
                [
                  btrfsCmd
                  "scrub"
                  "start"
                  "-B"
                ]
                ++ additionalScrubArgs
              )
            } %f";
            # if the service is stopped before scrub end, cancel it
            ExecStop = "${utils.escapeSystemdExecArg btrfsCancelCmd} %f";
            # hardening
            # required for starting/cancelling the scrub operation
            CapabilityBoundingSet = [
              "CAP_SYS_ADMIN"
              "CAP_DAC_READ_SEARCH"
            ];
            NoNewPrivileges = true;
            # no ProtectSystem/ProtectHome since the path to be scrubbed can refer to a device,
            # which in turn might be mounted there and mounting it read-only prevents scrubbing
            StateDirectory = "btrfs"; # contains progress information
            PrivateNetwork = true;
            ProtectHostname = true;
            ProtectClock = true;
            ProtectKernelModules = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            RestrictAddressFamilies = [ "AF_UNIX" ]; # used internally for communication
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            PrivateMounts = true;
            SystemCallFilter = [
              "@system-service"
              "~@mount"
            ];
            SystemCallArchitectures = "native";
            # no ProtectKernelTunables since /sys/fs/btrfs access is required
            # no User= since written files have to be accessible by scrub commands run manually
          };
      };

      systemd.timers."btrfs-scrub@" = {
        description = "Regular btrfs scrub on %f";
        documentation = [ "man:btrfs-scrub(8)" ];

        timerConfig = {
          OnCalendar = cfgScrub.interval;
          AccuracySec = "1d";
          Persistent = true;
        };
      };

      systemd.targets.timers.wants = map (
        fs: "btrfs-scrub@${utils.escapeSystemdPath fs}.timer"
      ) cfgScrub.fileSystems;
    })
  ];
}
