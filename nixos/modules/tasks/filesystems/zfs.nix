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

  inInitrd = any (fs: fs == "zfs") config.boot.initrd.supportedFilesystems;
  inSystem = any (fs: fs == "zfs") config.boot.supportedFilesystems;

  enableAutoSnapshots = cfgSnapshots.enable;
  enableZfs = inInitrd || inSystem || enableAutoSnapshots;

  kernel = config.boot.kernelPackages;

  splPkg = if cfgZfs.useGit then kernel.spl_git else kernel.spl;
  zfsPkg = if cfgZfs.useGit then kernel.zfs_git else kernel.zfs;

  autosnapPkg = pkgs.zfstools.override {
    zfs = zfsPkg;
  };

  zfsAutoSnap = "${autosnapPkg}/bin/zfs-auto-snapshot";

  datasetToPool = x: elemAt (splitString "/" x) 0;

  fsToPool = fs: datasetToPool fs.device;

  zfsFilesystems = filter (x: x.fsType == "zfs") (attrValues config.fileSystems);

  isRoot = fs: fs.neededForBoot || elem fs.mountPoint [ "/" "/nix" "/nix/store" "/var" "/var/log" "/var/lib" "/etc" ];

  allPools = unique ((map fsToPool zfsFilesystems) ++ cfgZfs.extraPools);

  rootPools = unique (map fsToPool (filter isRoot zfsFilesystems));

  dataPools = unique (filter (pool: !(elem pool rootPools)) allPools);

in

{

  ###### interface

  options = {
    boot.zfs = {
      useGit = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Use the git version of the SPL and ZFS packages.
          Note that these are unreleased versions, with less testing, and therefore
          may be more unstable.
        '';
      };

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

      forceImportRoot = mkOption {
        type = types.bool;
        default = true;
        example = false;
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
        example = false;
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
        extraModulePackages = [ splPkg zfsPkg ];
      };

      boot.initrd = mkIf inInitrd {
        kernelModules = [ "spl" "zfs" ];
        extraUtilsCommands =
          ''
            cp -v ${zfsPkg}/sbin/zfs $out/bin
            cp -v ${zfsPkg}/sbin/zdb $out/bin
            cp -v ${zfsPkg}/sbin/zpool $out/bin
            cp -pdv ${zfsPkg}/lib/lib*.so* $out/lib
            cp -pdv ${pkgs.zlib}/lib/lib*.so* $out/lib
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
            echo "importing root ZFS pool \"${pool}\"..."
            zpool import -N $ZFS_FORCE "${pool}"
        '') rootPools));
      };

      boot.loader.grub = mkIf inInitrd {
        zfsSupport = true;
      };

      environment.etc."zfs/zed.d".source = "${zfsPkg}/etc/zfs/zed.d/*";

      system.fsPackages = [ zfsPkg ];                  # XXX: needed? zfs doesn't have (need) a fsck
      environment.systemPackages = [ zfsPkg ];
      services.udev.packages = [ zfsPkg ];             # to hook zvol naming, etc.
      systemd.packages = [ zfsPkg ];

      systemd.services = let
        getPoolFilesystems = pool:
          filter (x: x.fsType == "zfs" && (fsToPool x) == pool) (attrValues config.fileSystems);

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
              zpool_cmd="${zfsPkg}/sbin/zpool"
              ("$zpool_cmd" list "${pool}" >/dev/null) || "$zpool_cmd" import -N ${optionalString cfgZfs.forceImportAll "-f"} "${pool}"
            '';
          };
      in listToAttrs (map createImportService dataPools) // {
        "zfs-mount" = { after = [ "systemd-modules-load.service" ]; };
        "zfs-share" = { after = [ "systemd-modules-load.service" ]; };
        "zed" = { after = [ "systemd-modules-load.service" ]; };
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
      systemd.services."zfs-snapshot-frequent" = {
        description = "ZFS auto-snapshotting every 15 mins";
        after = [ "zfs-import.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zfsAutoSnap} frequent ${toString cfgSnapshots.frequent}";
        };
        restartIfChanged = false;
        startAt = "*:15,30,45";
      };

      systemd.services."zfs-snapshot-hourly" = {
        description = "ZFS auto-snapshotting every hour";
        after = [ "zfs-import.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zfsAutoSnap} hourly ${toString cfgSnapshots.hourly}";
        };
        restartIfChanged = false;
        startAt = "hourly";
      };

      systemd.services."zfs-snapshot-daily" = {
        description = "ZFS auto-snapshotting every day";
        after = [ "zfs-import.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zfsAutoSnap} daily ${toString cfgSnapshots.daily}";
        };
        restartIfChanged = false;
        startAt = "daily";
      };

      systemd.services."zfs-snapshot-weekly" = {
        description = "ZFS auto-snapshotting every week";
        after = [ "zfs-import.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zfsAutoSnap} weekly ${toString cfgSnapshots.weekly}";
        };
        restartIfChanged = false;
        startAt = "weekly";
      };

      systemd.services."zfs-snapshot-monthly" = {
        description = "ZFS auto-snapshotting every month";
        after = [ "zfs-import.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zfsAutoSnap} monthly ${toString cfgSnapshots.monthly}";
        };
        restartIfChanged = false;
        startAt = "monthly";
      };
    })
  ];
}
