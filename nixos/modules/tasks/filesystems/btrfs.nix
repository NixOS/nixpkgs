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

  cfgScrub = config.services.btrfs.autoScrub;

  enableAutoScrub = cfgScrub.enable;
  enableBtrfs = inInitrd || inSystem || enableAutoScrub;

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

        unitConfig.RequiresMountsFor = "%f";

        serviceConfig =
          let
            btrfsCmd = getExe pkgs.btrfs-progs;
            btrfsCancelCmd = pkgs.writers.writePython3 "btrfs-scrub-maybe-cancel" { } ''
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
