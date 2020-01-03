{ config, lib, pkgs, utils, ... }:
#
# TODO: zfs tunables

with utils;
with lib;

let

  cfgZfs = config.boot.zfs;
  cfgSnapshots = config.services.zfs.autoSnapshot;
  cfgSnapFlags = cfgSnapshots.flags;
  cfgScrub = config.services.zfs.autoScrub;
  cfgTrim = config.services.zfs.trim;
  cfgZED = config.services.zfs.zed;

  inInitrd = any (fs: fs == "zfs") config.boot.initrd.supportedFilesystems;
  inSystem = any (fs: fs == "zfs") config.boot.supportedFilesystems;

  enableZfs = inInitrd || inSystem;

  kernel = config.boot.kernelPackages;

  packages = if config.boot.zfs.enableUnstable then {
    zfs = kernel.zfsUnstable;
    zfsUser = pkgs.zfsUnstable;
  } else {
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

  # When importing ZFS pools, there's one difficulty: These scripts may run
  # before the backing devices (physical HDDs, etc.) of the pool have been
  # scanned and initialized.
  #
  # An attempted import with all devices missing will just fail, and can be
  # retried, but an import where e.g. two out of three disks in a three-way
  # mirror are missing, will succeed. This is a problem: When the missing disks
  # are later discovered, they won't be automatically set online, rendering the
  # pool redundancy-less (and far slower) until such time as the system reboots.
  #
  # The solution is the below. poolReady checks the status of an un-imported
  # pool, to see if *every* device is available -- in which case the pool will be
  # in state ONLINE, as opposed to DEGRADED, FAULTED or MISSING.
  #
  # The import scripts then loop over this, waiting until the pool is ready or a
  # sufficient amount of time has passed that we can assume it won't be. In the
  # latter case it makes one last attempt at importing, allowing the system to
  # (eventually) boot even with a degraded pool.
  importLib = {zpoolCmd, awkCmd, cfgZfs}: ''
    poolReady() {
      pool="$1"
      state="$("${zpoolCmd}" import 2>/dev/null | "${awkCmd}" "/pool: $pool/ { found = 1 }; /state:/ { if (found == 1) { print \$2; exit } }; END { if (found == 0) { print \"MISSING\" } }")"
      if [[ "$state" = "ONLINE" ]]; then
        return 0
      else
        echo "Pool $pool in state $state, waiting"
        return 1
      fi
    }
    poolImported() {
      pool="$1"
      "${zpoolCmd}" list "$pool" >/dev/null 2>/dev/null
    }
    poolImport() {
      pool="$1"
      "${zpoolCmd}" import -d "${cfgZfs.devNodes}" -N $ZFS_FORCE "$pool"
    }
  '';

  zedConf = generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault {
      mkValueString = v:
        if isInt           v then toString v
        else if isString   v then "\"${v}\""
        else if true  ==   v then "1"
        else if false ==   v then "0"
        else if isList     v then "\"" + (concatStringsSep " " v) + "\""
        else err "this value is" (toString v);
    } "=";
  } cfgZED.settings;
in

{

  imports = [
    (mkRemovedOptionModule [ "boot" "zfs" "enableLegacyCrypto" ] "The corresponding package was removed from nixpkgs.")
  ];

  ###### interface

  options = {
    boot.zfs = {
      enableUnstable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Use the unstable zfs package. This might be an option, if the latest
          kernel is not yet supported by a published release of ZFS. Enabling
          this option will install a development version of ZFS on Linux. The
          version will have already passed an extensive test suite, but it is
          more likely to hit an undiscovered bug compared to running a released
          version of ZFS on Linux.
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

      requestEncryptionCredentials = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Request encryption keys or passwords for all encrypted datasets on import.
          For root pools the encryption key can be supplied via both an
          interactive prompt (keylocation=prompt) and from a file
          (keylocation=file://). Note that for data pools the encryption key can
          be only loaded from a file and not via interactive prompt since the
          import is processed in a background systemd service.
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

    services.zfs.trim = {
      enable = mkOption {
        description = "Whether to enable periodic TRIM on all ZFS pools.";
        default = true;
        example = false;
        type = types.bool;
      };

      interval = mkOption {
        default = "weekly";
        type = types.str;
        example = "daily";
        description = ''
          How often we run trim. For most desktop and server systems
          a sufficient trimming frequency is once a week.

          The format is described in
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>.
        '';
      };
    };

    services.zfs.autoScrub = {
      enable = mkEnableOption "Enables periodic scrubbing of ZFS pools.";

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

    services.zfs.zed.settings = mkOption {
      type = with types; attrsOf (oneOf [ str int bool (listOf str) ]);
      example = literalExample ''
        {
          ZED_DEBUG_LOG = "/tmp/zed.debug.log";

          ZED_EMAIL_ADDR = [ "root" ];
          ZED_EMAIL_PROG = "mail";
          ZED_EMAIL_OPTS = "-s '@SUBJECT@' @ADDRESS@";

          ZED_NOTIFY_INTERVAL_SECS = 3600;
          ZED_NOTIFY_VERBOSE = false;

          ZED_USE_ENCLOSURE_LEDS = true;
          ZED_SCRUB_AFTER_RESILVER = false;
        }
      '';
      description = ''
        ZFS Event Daemon /etc/zfs/zed.d/zed.rc content

        See
        <citerefentry><refentrytitle>zed</refentrytitle><manvolnum>8</manvolnum></citerefentry>
        for details on ZED and the scripts in /etc/zfs/zed.d to find the possible variables
      '';
    };
  };

  ###### implementation

  config = mkMerge [
    (mkIf enableZfs {
      assertions = [
        {
          assertion = config.networking.hostId != null;
          message = "ZFS requires networking.hostId to be set";
        }
        {
          assertion = !cfgZfs.forceImportAll || cfgZfs.forceImportRoot;
          message = "If you enable boot.zfs.forceImportAll, you must also enable boot.zfs.forceImportRoot";
        }
      ];

      virtualisation.lxd.zfsSupport = true;

      boot = {
        kernelModules = [ "zfs" ];
        extraModulePackages = with packages; [ zfs ];
      };

      boot.initrd = mkIf inInitrd {
        kernelModules = [ "zfs" ] ++ optional (!cfgZfs.enableUnstable) "spl";
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
          ''] ++ [(importLib {
            # See comments at importLib definition.
            zpoolCmd = "zpool";
            awkCmd = "awk";
            inherit cfgZfs;
          })] ++ (map (pool: ''
            echo -n "importing root ZFS pool \"${pool}\"..."
            # Loop across the import until it succeeds, because the devices needed may not be discovered yet.
            if ! poolImported "${pool}"; then
              for trial in `seq 1 60`; do
                poolReady "${pool}" > /dev/null && msg="$(poolImport "${pool}" 2>&1)" && break
                sleep 1
                echo -n .
              done
              echo
              if [[ -n "$msg" ]]; then
                echo "$msg";
              fi
              poolImported "${pool}" || poolImport "${pool}"  # Try one last time, e.g. to import a degraded pool.
            fi
            ${lib.optionalString cfgZfs.requestEncryptionCredentials ''
              zfs load-key -a
            ''}
        '') rootPools));
      };

      boot.loader.grub = mkIf inInitrd {
        zfsSupport = true;
      };

      services.zfs.zed.settings = {
        ZED_EMAIL_PROG = mkDefault "${pkgs.mailutils}/bin/mail";
      };

      environment.etc = genAttrs
        (map
          (file: "zfs/zed.d/${file}")
          [
            "all-syslog.sh"
            "pool_import-led.sh"
            "resilver_finish-start-scrub.sh"
            "statechange-led.sh"
            "vdev_attach-led.sh"
            "zed-functions.sh"
            "data-notify.sh"
            "resilver_finish-notify.sh"
            "scrub_finish-notify.sh"
            "statechange-notify.sh"
            "vdev_clear-led.sh"
          ]
        )
        (file: { source = "${packages.zfsUser}/etc/${file}"; })
      // {
        "zfs/zed.d/zed.rc".text = zedConf;
        "zfs/zpool.d".source = "${packages.zfsUser}/etc/zfs/zpool.d/";
      };

      system.fsPackages = [ packages.zfsUser ]; # XXX: needed? zfs doesn't have (need) a fsck
      environment.systemPackages = [ packages.zfsUser ]
        ++ optional cfgSnapshots.enable autosnapPkg; # so the user can run the command to see flags

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
            script = (importLib {
              # See comments at importLib definition.
              zpoolCmd="${packages.zfsUser}/sbin/zpool";
              awkCmd="${pkgs.gawk}/bin/awk";
              inherit cfgZfs;
            }) + ''
              poolImported "${pool}" && exit
              echo -n "importing ZFS pool \"${pool}\"..."
              # Loop across the import until it succeeds, because the devices needed may not be discovered yet.
              for trial in `seq 1 60`; do
                poolReady "${pool}" && poolImport "${pool}" && break
                sleep 1
              done
              poolImported "${pool}" || poolImport "${pool}"  # Try one last time, e.g. to import a degraded pool.
              if poolImported "${pool}"; then
                ${optionalString cfgZfs.requestEncryptionCredentials "\"${packages.zfsUser}/sbin/zfs\" load-key -r \"${pool}\""}
                echo "Successfully imported ${pool}"
              else
                exit 1
              fi
            '';
          };

        # This forces a sync of any ZFS pools prior to poweroff, even if they're set
        # to sync=disabled.
        createSyncService = pool:
          nameValuePair "zfs-sync-${pool}" {
            description = "Sync ZFS pool \"${pool}\"";
            wantedBy = [ "shutdown.target" ];
            unitConfig = {
              DefaultDependencies = false;
            };
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              ${packages.zfsUser}/sbin/zfs set nixos:shutdown-time="$(date)" "${pool}"
            '';
          };
        createZfsService = serv:
          nameValuePair serv {
            after = [ "systemd-modules-load.service" ];
            wantedBy = [ "zfs.target" ];
          };

      in listToAttrs (map createImportService dataPools ++
                      map createSyncService allPools ++
                      map createZfsService [ "zfs-mount" "zfs-share" "zfs-zed" ]);

      systemd.targets.zfs-import =
        let
          services = map (pool: "zfs-import-${pool}.service") dataPools;
        in
          {
            requires = services;
            after = services;
            wantedBy = [ "zfs.target" ];
          };

      systemd.targets.zfs.wantedBy = [ "multi-user.target" ];
    })

    (mkIf (enableZfs && cfgSnapshots.enable) {
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
                         timer = name: if name == "frequent" then "*:0,15,30,45" else name;
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

    (mkIf (enableZfs && cfgScrub.enable) {
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
        after = [ "multi-user.target" ]; # Apparently scrubbing before boot is complete hangs the system? #53583
        timerConfig = {
          OnCalendar = cfgScrub.interval;
          Persistent = "yes";
        };
      };
    })

    (mkIf (enableZfs && cfgTrim.enable) {
      systemd.services.zpool-trim = {
        description = "ZFS pools trim";
        after = [ "zfs-import.target" ];
        path = [ packages.zfsUser ];
        startAt = cfgTrim.interval;
        serviceConfig.ExecStart = "${pkgs.runtimeShell} -c 'zpool list -H -o name | xargs --no-run-if-empty -n1 zpool trim'";
      };
    })
  ];
}
