{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
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
    versionOlder
    ;

  inInitrd = config.boot.initrd.supportedFilesystems.btrfs or false;
  inSystem = config.boot.supportedFilesystems.btrfs or false;
  kernelVersion = config.boot.kernelPackages.kernel.version;

  cfgScrub = config.services.btrfs.autoScrub;
  cfgReclaim = config.services.btrfs.autoReclaim;

  enableAutoScrub = cfgScrub.enable;
  enableAutoReclaim = cfgReclaim.enable;
  enableBtrfs = inInitrd || inSystem || enableAutoScrub || enableAutoReclaim;

in

{
  options = {
    # One could also do regular btrfs balances, but that shouldn't be necessary
    # during normal usage and as long as the filesystems aren't filled near capacity
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

    services.btrfs.autoReclaim = {
      enable = mkEnableOption "automatic background reclaim threshold for btrfs filesystems" // {
        description = ''
          Whether to enable automatic relocation of mostly-empty btrfs block
          groups.

          On write-heavy filesystems, freed space gets stranded in small block
          groups, leading to failures such as "No space left on device" even
          though plenty of space is free. When enabled, the kernel relocates
          such block groups in the background as their usage falls below the
          configured threshold. Filesystems mounted after boot are configured
          on the next boot.

          For details, see [balance docs](https://btrfs.readthedocs.io/en/latest/Balance.html)
          and [sysfs docs](https://btrfs.readthedocs.io/en/latest/Administration.html#uuid-allocations-data-metadata-system).
        '';
      };

      dataThreshold = mkOption {
        default = null;
        defaultText = "10, or null if {option}`services.btrfs.autoReclaim.dynamicReclaim` is enabled";
        type = types.nullOr (types.ints.between 0 100);
        example = 75;
        description = ''
          Percentage of a data block group's space usage below which the
          kernel relocates the block group in the background.

          Only available on Linux kernel 5.19 and later. Set to null to leave
          it at its [kernel default](https://btrfs.readthedocs.io/en/latest/Administration.html#uuid-allocations-data-metadata-system).

          ::: {.warning}
          Setting this value too high can cause excessive write amplification
          on SSDs due to frequent block group relocations.
          :::
        '';
      };

      metadataThreshold = mkOption {
        default = null;
        defaultText = "50, or null if {option}`services.btrfs.autoReclaim.dynamicReclaim` is enabled";
        type = types.nullOr (types.ints.between 0 100);
        example = 75;
        description = ''
          Percentage of a metadata block group's space usage below which the
          kernel relocates the block group in the background.

          Only available on Linux kernel 5.19 and later. Set to null to leave
          it at its [kernel default](https://btrfs.readthedocs.io/en/latest/Administration.html#uuid-allocations-data-metadata-system).

          ::: {.warning}
          Setting this value too high can cause excessive write amplification
          on SSDs due to frequent block group relocations.
          :::
        '';
      };

      dynamicReclaim = mkOption {
        default = false;
        defaultText = "true on Linux kernels 6.11 and later";
        type = types.bool;
        description = ''
          Whether to let the kernel compute the reclaim threshold by itself,
          instead of {option}`dataThreshold` and {option}`metadataThreshold`.

          The kernel reclaims only while the filesystem runs low on
          unallocated space, keeping write amplification near zero otherwise.
          Only available on Linux kernel 6.11 and later. See [the kernel's
          reclaim settings](https://btrfs.readthedocs.io/en/latest/Administration.html#uuid-allocations-data-metadata-system) for details.
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

      boot.initrd.systemd.initrdBin = [ pkgs.btrfs-progs ];
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

      # This will remove duplicated units from either having a filesystem mounted multiple
      # time, or additionally mounted subvolumes, as well as having a filesystem span
      # multiple devices (provided the same device is used to mount said filesystem).
      services.btrfs.autoScrub.fileSystems =
        let
          isDeviceInList = list: device: builtins.filter (e: e.device == device) list != [ ];

          uniqueDeviceList = foldl' (acc: e: if isDeviceInList acc e.device then acc else acc ++ [ e ]) [ ];
        in
        mkDefault (
          map (e: e.mountPoint) (
            uniqueDeviceList (
              mapAttrsToList (name: fs: {
                mountPoint = fs.mountPoint;
                device = fs.device;
              }) (filterAttrs (name: fs: fs.fsType == "btrfs") config.fileSystems)
            )
          )
        );

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

    (mkIf enableAutoReclaim {
      # Let the kernel self-tune on kernels with support for it (6.11 and later),
      # and fall back to the fixed thresholds otherwise.
      services.btrfs.autoReclaim.dynamicReclaim = mkDefault (lib.versionAtLeast kernelVersion "6.11");
      services.btrfs.autoReclaim.dataThreshold = mkDefault (
        if cfgReclaim.dynamicReclaim then null else 10
      );
      services.btrfs.autoReclaim.metadataThreshold = mkDefault (
        if cfgReclaim.dynamicReclaim then null else 50
      );

      assertions = [
        {
          assertion = lib.versionAtLeast kernelVersion "5.19";
          message = ''
            services.btrfs.autoReclaim requires Linux kernel 5.19 or later.
          '';
        }
        {
          assertion = cfgReclaim.dynamicReclaim -> lib.versionAtLeast kernelVersion "6.11";
          message = ''
            services.btrfs.autoReclaim.dynamicReclaim requires Linux kernel 6.11 or later.
          '';
        }
        {
          # The kernel rejects fixed-threshold writes while dynamic reclaim is on.
          assertion =
            cfgReclaim.dynamicReclaim
            -> cfgReclaim.dataThreshold == null && cfgReclaim.metadataThreshold == null;
          message = ''
            services.btrfs.autoReclaim: dynamicReclaim ignores dataThreshold and
            metadataThreshold because the kernel rejects threshold writes while
            dynamic reclaim is enabled. Leave both thresholds unset, or disable
            dynamicReclaim.
          '';
        }
      ];

      # Nothing gets reclaimed with dynamic reclaim off and no thresholds set.
      warnings =
        lib.optionals
          (
            !cfgReclaim.dynamicReclaim
            && cfgReclaim.dataThreshold == null
            && cfgReclaim.metadataThreshold == null
          )
          [
            ''
              services.btrfs.autoReclaim is enabled with dynamic reclaim off and
              no thresholds set, so nothing will be reclaimed. Set
              dataThreshold or metadataThreshold, or enable dynamicReclaim.
            ''
          ];

      # udev rules never match the /sys/fs/btrfs entries (they carry no
      # SUBSYSTEM), so set the attributes at boot via systemd-tmpfiles.
      # dynamic_reclaim is written unconditionally, since the kernel rejects
      # threshold writes while it is on; it must be cleared first when toggled off.
      systemd.tmpfiles.rules = [
        "w /sys/fs/btrfs/*/allocation/data/dynamic_reclaim - - - - ${
          if cfgReclaim.dynamicReclaim then "1" else "0"
        }"
        "w /sys/fs/btrfs/*/allocation/metadata/dynamic_reclaim - - - - ${
          if cfgReclaim.dynamicReclaim then "1" else "0"
        }"
      ]
      ++ optionals (cfgReclaim.dataThreshold != null) [
        "w /sys/fs/btrfs/*/allocation/data/bg_reclaim_threshold - - - - ${toString cfgReclaim.dataThreshold}"
      ]
      ++ optionals (cfgReclaim.metadataThreshold != null) [
        "w /sys/fs/btrfs/*/allocation/metadata/bg_reclaim_threshold - - - - ${toString cfgReclaim.metadataThreshold}"
      ];
    })
  ];
}
