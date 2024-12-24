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
    nameValuePair
    listToAttrs
    filterAttrs
    mapAttrsToList
    foldl'
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

    };
  };

  config = mkMerge [
    (mkIf enableBtrfs {
      system.fsPackages = [ pkgs.btrfs-progs ];
    })

    (mkIf inInitrd {
      boot.initrd.kernelModules = [ "btrfs" ];
      boot.initrd.availableKernelModules =
        [ "crc32c" ]
        ++ optionals (config.boot.kernelPackages.kernel.kernelAtLeast "5.5") [
          # Needed for mounting filesystems with new checksums
          "xxhash_generic"
          "blake2b_generic"
          "sha256_generic" # Should be baked into our kernel, just to be sure
        ];

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

      # TODO: Did not manage to do it via the usual btrfs-scrub@.timer/.service
      # template units due to problems enabling the parameterized units,
      # so settled with many units and templating via nix for now.
      # https://github.com/NixOS/nixpkgs/pull/32496#discussion_r156527544
      systemd.timers =
        let
          scrubTimer =
            fs:
            let
              fs' = utils.escapeSystemdPath fs;
            in
            nameValuePair "btrfs-scrub-${fs'}" {
              description = "regular btrfs scrub timer on ${fs}";

              wantedBy = [ "timers.target" ];
              timerConfig = {
                OnCalendar = cfgScrub.interval;
                AccuracySec = "1d";
                Persistent = true;
              };
            };
        in
        listToAttrs (map scrubTimer cfgScrub.fileSystems);

      systemd.services =
        let
          scrubService =
            fs:
            let
              fs' = utils.escapeSystemdPath fs;
            in
            nameValuePair "btrfs-scrub-${fs'}" {
              description = "btrfs scrub on ${fs}";
              # scrub prevents suspend2ram or proper shutdown
              conflicts = [
                "shutdown.target"
                "sleep.target"
              ];
              before = [
                "shutdown.target"
                "sleep.target"
              ];

              serviceConfig = {
                # simple and not oneshot, otherwise ExecStop is not used
                Type = "simple";
                Nice = 19;
                IOSchedulingClass = "idle";
                ExecStart = "${pkgs.btrfs-progs}/bin/btrfs scrub start -B ${fs}";
                # if the service is stopped before scrub end, cancel it
                ExecStop = pkgs.writeShellScript "btrfs-scrub-maybe-cancel" ''
                  (${pkgs.btrfs-progs}/bin/btrfs scrub status ${fs} | ${pkgs.gnugrep}/bin/grep finished) || ${pkgs.btrfs-progs}/bin/btrfs scrub cancel ${fs}
                '';
              };
            };
        in
        listToAttrs (map scrubService cfgScrub.fileSystems);
    })
  ];
}
