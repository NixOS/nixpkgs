{ config, lib, pkgs, utils, ... }:
#
# todo:
#   - crontab for scrubs, etc
#   - zfs tunables

with utils;
with lib;

let

  cfgSpl = config.boot.spl;
  cfgZfs = config.boot.zfs;
  cfgSnapshots = config.services.zfs.autoSnapshot;
  cfgSnapFlags = cfgSnapshots.flags;
  cfgScrub = config.services.zfs.autoScrub;

  inInitrd = any (fs: fs == "zfs") config.boot.initrd.supportedFilesystems;
  inSystem = any (fs: fs == "zfs") config.boot.supportedFilesystems;

  enableAutoSnapshots = cfgSnapshots.enable;
  enableAutoScrub = cfgScrub.enable;
  enableZfs = inInitrd || inSystem || enableAutoSnapshots || enableAutoScrub;

  kernel = config.boot.kernelPackages;

  packages = {
    spl = kernel.spl;
    zfs = kernel.zfs;
    zfsUser = pkgs.zfs;
  };

  autosnapPkg = pkgs.zfstools.override {
    zfs = packages.zfsUser;
  };

  zfsAutoSnap = "${autosnapPkg}/bin/zfs-auto-snapshot";

  datasetToPool = x: elemAt (splitString "/" x) 0;

  fsToPool = fs: datasetToPool fs.device;

  zfsFilesystems = filter (x: x.fsType == "zfs") config.system.build.fileSystems;

  allPools = unique ((map fsToPool zfsFilesystems) ++ cfgZfs.extraPools);

  rootPools = unique (map fsToPool (filter fsNeededForBoot zfsFilesystems));

  dataPools = unique (filter (pool: !(elem pool rootPools)) allPools);

  snapshotNames = [ "frequent" "hourly" "daily" "weekly" "monthly" ];

in

{

  ###### interface

  options = {
    boot.zfs = {
      extraPools = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "tank" "data" ];
        description = ''
          Name or GUID of extra ZFS pools that you wish to import during boot.

          Usually this is not necessary. Instead, you should set the mountpoint property
          of ZFS filesystems to <literal>legacy</literal> and add the ZFS filesystems to
          NixOS's <option>fileSystems</option> option, which makes NixOS automatically
          import the associated pool.

          However, in some cases (e.g. if you have many filesystems) it may be preferable
          to exclusively use ZFS commands to manage filesystems. If so, since NixOS/systemd
          will not be managing those filesystems, you will need to specify the ZFS pool here
          so that NixOS automatically imports it on every boot.
        '';
      };

      devNodes = mkOption {
        type = types.path;
        default = "/dev/disk/by-id";
        example = "/dev/disk/by-id";
        description = ''
          Name of directory from which to import ZFS devices.

          This should be a path under /dev containing stable names for all devices needed, as
          import may fail if device nodes are renamed concurrently with a device failing.
        '';
      };

      forceImportRoot = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Forcibly import the ZFS root pool(s) during early boot.

          This is enabled by default for backwards compatibility purposes, but it is highly
          recommended to disable this option, as it bypasses some of the safeguards ZFS uses
          to protect your ZFS pools.

          If you set this option to <literal>false</literal> and NixOS subsequently fails to
          boot because it cannot import the root pool, you should boot with the
          <literal>zfs_force=1</literal> option as a kernel parameter (e.g. by manually
          editing the kernel params in grub during boot). You should only need to do this
          once.
        '';
      };

      forceImportAll = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Forcibly import all ZFS pool(s).

          This is enabled by default for backwards compatibility purposes, but it is highly
          recommended to disable this option, as it bypasses some of the safeguards ZFS uses
          to protect your ZFS pools.

          If you set this option to <literal>false</literal> and NixOS subsequently fails to
          import your non-root ZFS pool(s), you should manually import each pool with
          "zpool import -f &lt;pool-name&gt;", and then reboot. You should only need to do
          this once.
        '';
      };
    };

    services.zfs.autoSnapshot = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable the (OpenSolaris-compatible) ZFS auto-snapshotting service.
          Note that you must set the <literal>com.sun:auto-snapshot</literal>
          property to <literal>true</literal> on all datasets which you wish
          to auto-snapshot.

          You can override a child dataset to use, or not use auto-snapshotting
          by setting its flag with the given interval:
          <literal>zfs set com.sun:auto-snapshot:weekly=false DATASET</literal>
        '';
      };

      flags = mkOption {
        default = "-k -p";
        example = "-k -p --utc";
        type = types.str;
        description = ''
          Flags to pass to the zfs-auto-snapshot command.

          Run <literal>zfs-auto-snapshot</literal> (without any arguments) to
          see available flags.

          If it's not too inconvenient for snapshots to have timestamps in UTC,
          it is suggested that you append <literal>--utc</literal> to the list
          of default options (see example).

          Otherwise, snapshot names can cause name conflicts or apparent time
          reversals due to daylight savings, timezone or other date/time changes.
        '';
      };

      frequent = mkOption {
        default = 4;
        type = types.int;
        description = ''
          Number of frequent (15-minute) auto-snapshots that you wish to keep.
        '';
      };

      hourly = mkOption {
        default = 24;
        type = types.int;
        description = ''
          Number of hourly auto-snapshots that you wish to keep.
        '';
      };

      daily = mkOption {
        default = 7;
        type = types.int;
        description = ''
          Number of daily auto-snapshots that you wish to keep.
        '';
      };

      weekly = mkOption {
        default = 4;
        type = types.int;
        description = ''
          Number of weekly auto-snapshots that you wish to keep.
        '';
      };

      monthly = mkOption {
        default = 12;
        type = types.int;
        description = ''
          Number of monthly auto-snapshots that you wish to keep.
        '';
      };
    };

    services.zfs.autoScrub = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enables periodic scrubbing of ZFS pools.
        '';
      };

      interval = mkOption {
        default = "Sun, 02:00";
        type = types.str;
        example = "daily";
        description = ''
          Systemd calendar expression when to scrub ZFS pools. See
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>.
        '';
      };

      pools = mkOption {
        default = [];
        type = types.listOf types.str;
        example = [ "tank" ];
        description = ''
          List of ZFS pools to periodically scrub. If empty, all pools
          will be scrubbed.
        '';
      };
    };
  };

  ###### implementation

  config = mkMerge [
    (mkIf enableZfs {
      assertions = [
        {
          assertion = config.networking.hostId != null;
          message = "ZFS requires config.networking.hostId to be set";
        }
        {
          assertion = !cfgZfs.forceImportAll || cfgZfs.forceImportRoot;
          message = "If you enable boot.zfs.forceImportAll, you must also enable boot.zfs.forceImportRoot";
        }
      ];

      boot = {
        kernelModules = [ "spl" "zfs" ] ;
        extraModulePackages = with packages; [ spl zfs ];
      };

      boot.initrd = mkIf inInitrd {
        kernelModules = [ "spl" "zfs" ];
        extraUtilsCommands =
          ''
            copy_bin_and_libs ${packages.zfsUser}/sbin/zfs
            copy_bin_and_libs ${packages.zfsUser}/sbin/zdb
            copy_bin_and_libs ${packages.zfsUser}/sbin/zpool
          '';
        extraUtilsCommandsTest = mkIf inInitrd
          ''
            $out/bin/zfs --help >/dev/null 2>&1
            $out/bin/zpool --help >/dev/null 2>&1
          '';
        postDeviceCommands = concatStringsSep "\n" ([''
            ZFS_FORCE="${optionalString cfgZfs.forceImportRoot "-f"}"

            for o in $(cat /proc/cmdline); do
              case $o in
                zfs_force|zfs_force=1)
                  ZFS_FORCE="-f"
                  ;;
              esac
            done
            ''] ++ (map (pool: ''
            echo -n "importing root ZFS pool \"${pool}\"..."
            trial=0
            until msg="$(zpool import -d ${cfgZfs.devNodes} -N $ZFS_FORCE '${pool}' 2>&1)"; do
              sleep 0.25
              echo -n .
              trial=$(($trial + 1))
              if [[ $trial -eq 60 ]]; then
                break
              fi
            done
            echo
            if [[ -n "$msg" ]]; then echo "$msg"; fi
        '') rootPools));
      };

      boot.loader.grub = mkIf inInitrd {
        zfsSupport = true;
      };

      environment.etc."zfs/zed.d".source = "${packages.zfsUser}/etc/zfs/zed.d/";

      system.fsPackages = [ packages.zfsUser ]; # XXX: needed? zfs doesn't have (need) a fsck
      environment.systemPackages = [ packages.zfsUser ]
        ++ optional enableAutoSnapshots autosnapPkg; # so the user can run the command to see flags

      services.udev.packages = [ packages.zfsUser ]; # to hook zvol naming, etc.
      systemd.packages = [ packages.zfsUser ];

      systemd.services = let
        getPoolFilesystems = pool:
          filter (x: x.fsType == "zfs" && (fsToPool x) == pool) config.system.build.fileSystems;

        getPoolMounts = pool:
          let
            mountPoint = fs: escapeSystemdPath fs.mountPoint;
          in
            map (x: "${mountPoint x}.mount") (getPoolFilesystems pool);

        createImportService = pool:
          nameValuePair "zfs-import-${pool}" {
            description = "Import ZFS pool \"${pool}\"";
            requires = [ "systemd-udev-settle.service" ];
            after = [ "systemd-udev-settle.service" "systemd-modules-load.service" ];
            wantedBy = (getPoolMounts pool) ++ [ "local-fs.target" ];
            before = (getPoolMounts pool) ++ [ "local-fs.target" ];
            unitConfig = {
              DefaultDependencies = "no";
            };
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              zpool_cmd="${packages.zfsUser}/sbin/zpool"
              ("$zpool_cmd" list "${pool}" >/dev/null) || "$zpool_cmd" import -d ${cfgZfs.devNodes} -N ${optionalString cfgZfs.forceImportAll "-f"} "${pool}"
            '';
          };

        # This forces a sync of any ZFS pools prior to poweroff, even if they're set
        # to sync=disabled.
        createSyncService = pool:
          nameValuePair "zfs-sync-${pool}" {
            description = "Sync ZFS pool \"${pool}\"";
            wantedBy = [ "shutdown.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              ${packages.zfsUser}/sbin/zfs set nixos:shutdown-time="$(date)" "${pool}"
            '';
          };

      in listToAttrs (map createImportService dataPools ++ map createSyncService allPools) // {
        "zfs-mount" = { after = [ "systemd-modules-load.service" ]; };
        "zfs-share" = { after = [ "systemd-modules-load.service" ]; };
        "zfs-zed" = { after = [ "systemd-modules-load.service" ]; };
      };

      systemd.targets."zfs-import" =
        let
          services = map (pool: "zfs-import-${pool}.service") dataPools;
        in
          {
            requires = services;
            after = services;
          };

      systemd.targets."zfs".wantedBy = [ "multi-user.target" ];
    })

    (mkIf enableAutoSnapshots {
      systemd.services = let
                           descr = name: if name == "frequent" then "15 mins"
                                    else if name == "hourly" then "hour"
                                    else if name == "daily" then "day"
                                    else if name == "weekly" then "week"
                                    else if name == "monthly" then "month"
                                    else throw "unknown snapshot name";
                           numSnapshots = name: builtins.getAttr name cfgSnapshots;
                         in builtins.listToAttrs (map (snapName:
                              {
                                name = "zfs-snapshot-${snapName}";
                                value = {
                                  description = "ZFS auto-snapshotting every ${descr snapName}";
                                  after = [ "zfs-import.target" ];
                                  serviceConfig = {
                                    Type = "oneshot";
                                    ExecStart = "${zfsAutoSnap} ${cfgSnapFlags} ${snapName} ${toString (numSnapshots snapName)}";
                                  };
                                  restartIfChanged = false;
                                };
                              }) snapshotNames);

      systemd.timers = let
                         timer = name: if name == "frequent" then "*:15,30,45" else name;
                       in builtins.listToAttrs (map (snapName:
                            {
                              name = "zfs-snapshot-${snapName}";
                              value = {
                                wantedBy = [ "timers.target" ];
                                timerConfig = {
                                  OnCalendar = timer snapName;
                                  Persistent = "yes";
                                };
                              };
                            }) snapshotNames);
    })

    (mkIf enableAutoScrub {
      systemd.services.zfs-scrub = {
        description = "ZFS pools scrubbing";
        after = [ "zfs-import.target" ];
        serviceConfig = {
          Type = "oneshot";
        };
        script = ''
          ${packages.zfsUser}/bin/zpool scrub ${
            if cfgScrub.pools != [] then
              (concatStringsSep " " cfgScrub.pools)
            else
              "$(${packages.zfsUser}/bin/zpool list -H -o name)"
            }
        '';
      };

      systemd.timers.zfs-scrub = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfgScrub.interval;
          Persistent = "yes";
        };
      };
    })
  ];
}
