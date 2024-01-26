{ config, lib, options, pkgs, utils, ... }:
#
# TODO: zfs tunables

with utils;
with lib;

let

  cfgZfs = config.boot.zfs;
  optZfs = options.boot.zfs;
  cfgExpandOnBoot = config.services.zfs.expandOnBoot;
  cfgSnapshots = config.services.zfs.autoSnapshot;
  cfgSnapFlags = cfgSnapshots.flags;
  cfgScrub = config.services.zfs.autoScrub;
  cfgTrim = config.services.zfs.trim;
  cfgZED = config.services.zfs.zed;

  selectModulePackage = package: config.boot.kernelPackages.${package.kernelModuleAttribute};
  clevisDatasets = map (e: e.device) (filter (e: e.device != null && (hasAttr e.device config.boot.initrd.clevis.devices) && e.fsType == "zfs" && (fsNeededForBoot e)) config.system.build.fileSystems);


  inInitrd = any (fs: fs == "zfs") config.boot.initrd.supportedFilesystems;
  inSystem = any (fs: fs == "zfs") config.boot.supportedFilesystems;

  autosnapPkg = pkgs.zfstools.override {
    zfs = cfgZfs.package;
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
    for o in $(cat /proc/cmdline); do
      case $o in
        zfs_force|zfs_force=1|zfs_force=y)
          ZFS_FORCE="-f"
          ;;
      esac
    done
    poolReady() {
      pool="$1"
      state="$("${zpoolCmd}" import -d "${cfgZfs.devNodes}" 2>/dev/null | "${awkCmd}" "/pool: $pool/ { found = 1 }; /state:/ { if (found == 1) { print \$2; exit } }; END { if (found == 0) { print \"MISSING\" } }")"
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

  getPoolFilesystems = pool:
    filter (x: x.fsType == "zfs" && (fsToPool x) == pool) config.system.build.fileSystems;

  getPoolMounts = prefix: pool:
    let
      poolFSes = getPoolFilesystems pool;

      # Remove the "/" suffix because even though most mountpoints
      # won't have it, the "/" mountpoint will, and we can't have the
      # trailing slash in "/sysroot/" in stage 1.
      mountPoint = fs: escapeSystemdPath (prefix + (lib.removeSuffix "/" fs.mountPoint));

      hasUsr = lib.any (fs: fs.mountPoint == "/usr") poolFSes;
    in
      map (x: "${mountPoint x}.mount") poolFSes
      ++ lib.optional hasUsr "sysusr-usr.mount";

  getKeyLocations = pool: if isBool cfgZfs.requestEncryptionCredentials then {
    hasKeys = cfgZfs.requestEncryptionCredentials;
    command = "${cfgZfs.package}/sbin/zfs list -rHo name,keylocation,keystatus -t volume,filesystem ${pool}";
  } else let
    keys = filter (x: datasetToPool x == pool) cfgZfs.requestEncryptionCredentials;
  in {
    hasKeys = keys != [];
    command = "${cfgZfs.package}/sbin/zfs list -Ho name,keylocation,keystatus -t volume,filesystem ${toString keys}";
  };

  createImportService = { pool, systemd, force, prefix ? "" }:
    nameValuePair "zfs-import-${pool}" {
      description = "Import ZFS pool \"${pool}\"";
      # We wait for systemd-udev-settle to ensure devices are available,
      # but don't *require* it, because mounts shouldn't be killed if it's stopped.
      # In the future, hopefully someone will complete this:
      # https://github.com/zfsonlinux/zfs/pull/4943
      wants = [ "systemd-udev-settle.service" ] ++ optional (config.boot.initrd.clevis.useTang) "network-online.target";
      after = [
        "systemd-udev-settle.service"
        "systemd-modules-load.service"
        "systemd-ask-password-console.service"
      ] ++ optional (config.boot.initrd.clevis.useTang) "network-online.target";
      requiredBy = getPoolMounts prefix pool ++ [ "zfs-import.target" ];
      before = getPoolMounts prefix pool ++ [ "shutdown.target" "zfs-import.target" ];
      conflicts = [ "shutdown.target" ];
      unitConfig = {
        DefaultDependencies = "no";
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      environment.ZFS_FORCE = optionalString force "-f";
      script = let
        keyLocations = getKeyLocations pool;
      in (importLib {
        # See comments at importLib definition.
        zpoolCmd = "${cfgZfs.package}/sbin/zpool";
        awkCmd = "${pkgs.gawk}/bin/awk";
        inherit cfgZfs;
      }) + ''
        if ! poolImported "${pool}"; then
          echo -n "importing ZFS pool \"${pool}\"..."
          # Loop across the import until it succeeds, because the devices needed may not be discovered yet.
          for trial in `seq 1 60`; do
            poolReady "${pool}" && poolImport "${pool}" && break
            sleep 1
          done
          poolImported "${pool}" || poolImport "${pool}"  # Try one last time, e.g. to import a degraded pool.
        fi
        if poolImported "${pool}"; then
        ${optionalString config.boot.initrd.clevis.enable (concatMapStringsSep "\n" (elem: "clevis decrypt < /etc/clevis/${elem}.jwe | zfs load-key ${elem} || true ") (filter (p: (elemAt (splitString "/" p) 0) == pool) clevisDatasets))}


          ${optionalString keyLocations.hasKeys ''
            ${keyLocations.command} | while IFS=$'\t' read ds kl ks; do
              {
              if [[ "$ks" != unavailable ]]; then
                continue
              fi
              case "$kl" in
                none )
                  ;;
                prompt )
                  tries=3
                  success=false
                  while [[ $success != true ]] && [[ $tries -gt 0 ]]; do
                    ${systemd}/bin/systemd-ask-password --timeout=${toString cfgZfs.passwordTimeout} "Enter key for $ds:" | ${cfgZfs.package}/sbin/zfs load-key "$ds" \
                      && success=true \
                      || tries=$((tries - 1))
                  done
                  [[ $success = true ]]
                  ;;
                * )
                  ${cfgZfs.package}/sbin/zfs load-key "$ds"
                  ;;
              esac
              } < /dev/null # To protect while read ds kl in case anything reads stdin
            done
          ''}
          echo "Successfully imported ${pool}"
        else
          exit 1
        fi
      '';
    };

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
      package = mkOption {
        type = types.package;
        default = if cfgZfs.enableUnstable then pkgs.zfsUnstable else pkgs.zfs;
        defaultText = literalExpression "if zfsUnstable is enabled then pkgs.zfsUnstable else pkgs.zfs";
        description = lib.mdDoc "Configured ZFS userland tools package, use `pkgs.zfsUnstable` if you want to track the latest staging ZFS branch.";
      };

      modulePackage = mkOption {
        internal = true; # It is supposed to be selected automatically, but can be overridden by expert users.
        default = selectModulePackage cfgZfs.package;
        type = types.package;
        description = lib.mdDoc "Configured ZFS kernel module package.";
      };

      enabled = mkOption {
        readOnly = true;
        type = types.bool;
        default = inInitrd || inSystem;
        defaultText = literalMD "`true` if ZFS filesystem support is enabled";
        description = lib.mdDoc "True if ZFS filesystem support is enabled";
      };

      enableUnstable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Use the unstable zfs package. This might be an option, if the latest
          kernel is not yet supported by a published release of ZFS. Enabling
          this option will install a development version of ZFS on Linux. The
          version will have already passed an extensive test suite, but it is
          more likely to hit an undiscovered bug compared to running a released
          version of ZFS on Linux.
          '';
      };

      allowHibernation = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Allow hibernation support, this may be a unsafe option depending on your
          setup. Make sure to NOT use Swap on ZFS.
        '';
      };

      extraPools = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "tank" "data" ];
        description = lib.mdDoc ''
          Name or GUID of extra ZFS pools that you wish to import during boot.

          Usually this is not necessary. Instead, you should set the mountpoint property
          of ZFS filesystems to `legacy` and add the ZFS filesystems to
          NixOS's {option}`fileSystems` option, which makes NixOS automatically
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
        description = lib.mdDoc ''
          Name of directory from which to import ZFS devices.

          This should be a path under /dev containing stable names for all devices needed, as
          import may fail if device nodes are renamed concurrently with a device failing.
        '';
      };

      forceImportRoot = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Forcibly import the ZFS root pool(s) during early boot.

          This is enabled by default for backwards compatibility purposes, but it is highly
          recommended to disable this option, as it bypasses some of the safeguards ZFS uses
          to protect your ZFS pools.

          If you set this option to `false` and NixOS subsequently fails to
          boot because it cannot import the root pool, you should boot with the
          `zfs_force=1` option as a kernel parameter (e.g. by manually
          editing the kernel params in grub during boot). You should only need to do this
          once.
        '';
      };

      forceImportAll = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Forcibly import all ZFS pool(s).

          If you set this option to `false` and NixOS subsequently fails to
          import your non-root ZFS pool(s), you should manually import each pool with
          "zpool import -f \<pool-name\>", and then reboot. You should only need to do
          this once.
        '';
      };

      requestEncryptionCredentials = mkOption {
        type = types.either types.bool (types.listOf types.str);
        default = true;
        example = [ "tank" "data" ];
        description = lib.mdDoc ''
          If true on import encryption keys or passwords for all encrypted datasets
          are requested. To only decrypt selected datasets supply a list of dataset
          names instead. For root pools the encryption key can be supplied via both
          an interactive prompt (keylocation=prompt) and from a file (keylocation=file://).
        '';
      };

      passwordTimeout = mkOption {
        type = types.int;
        default = 0;
        description = lib.mdDoc ''
          Timeout in seconds to wait for password entry for decrypt at boot.

          Defaults to 0, which waits forever.
        '';
      };

      removeLinuxDRM = lib.mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Linux 6.2 dropped some kernel symbols required on aarch64 required by zfs.
          Enabling this option will bring them back to allow this kernel version.
          Note that in some jurisdictions this may be illegal as it might be considered
          removing copyright protection from the code.
          See https://www.ifross.org/?q=en/artikel/ongoing-dispute-over-value-exportsymbolgpl-function for further information.

          If configure your kernel package with `zfs.latestCompatibleLinuxPackages`, you will need to also pass removeLinuxDRM to that package like this:

          ```
          { pkgs, ... }: {
            boot.kernelPackages = (pkgs.zfs.override {
              removeLinuxDRM = pkgs.hostPlatform.isAarch64;
            }).latestCompatibleLinuxPackages;

            boot.zfs.removeLinuxDRM = true;
          }
          ```
        '';
      };
    };

    services.zfs.autoSnapshot = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enable the (OpenSolaris-compatible) ZFS auto-snapshotting service.
          Note that you must set the `com.sun:auto-snapshot`
          property to `true` on all datasets which you wish
          to auto-snapshot.

          You can override a child dataset to use, or not use auto-snapshotting
          by setting its flag with the given interval:
          `zfs set com.sun:auto-snapshot:weekly=false DATASET`
        '';
      };

      flags = mkOption {
        default = "-k -p";
        example = "-k -p --utc";
        type = types.str;
        description = lib.mdDoc ''
          Flags to pass to the zfs-auto-snapshot command.

          Run `zfs-auto-snapshot` (without any arguments) to
          see available flags.

          If it's not too inconvenient for snapshots to have timestamps in UTC,
          it is suggested that you append `--utc` to the list
          of default options (see example).

          Otherwise, snapshot names can cause name conflicts or apparent time
          reversals due to daylight savings, timezone or other date/time changes.
        '';
      };

      frequent = mkOption {
        default = 4;
        type = types.int;
        description = lib.mdDoc ''
          Number of frequent (15-minute) auto-snapshots that you wish to keep.
        '';
      };

      hourly = mkOption {
        default = 24;
        type = types.int;
        description = lib.mdDoc ''
          Number of hourly auto-snapshots that you wish to keep.
        '';
      };

      daily = mkOption {
        default = 7;
        type = types.int;
        description = lib.mdDoc ''
          Number of daily auto-snapshots that you wish to keep.
        '';
      };

      weekly = mkOption {
        default = 4;
        type = types.int;
        description = lib.mdDoc ''
          Number of weekly auto-snapshots that you wish to keep.
        '';
      };

      monthly = mkOption {
        default = 12;
        type = types.int;
        description = lib.mdDoc ''
          Number of monthly auto-snapshots that you wish to keep.
        '';
      };
    };

    services.zfs.trim = {
      enable = mkOption {
        description = lib.mdDoc "Whether to enable periodic TRIM on all ZFS pools.";
        default = true;
        example = false;
        type = types.bool;
      };

      interval = mkOption {
        default = "weekly";
        type = types.str;
        example = "daily";
        description = lib.mdDoc ''
          How often we run trim. For most desktop and server systems
          a sufficient trimming frequency is once a week.

          The format is described in
          {manpage}`systemd.time(7)`.
        '';
      };
    };

    services.zfs.autoScrub = {
      enable = mkEnableOption (lib.mdDoc "periodic scrubbing of ZFS pools");

      interval = mkOption {
        default = "Sun, 02:00";
        type = types.str;
        example = "daily";
        description = lib.mdDoc ''
          Systemd calendar expression when to scrub ZFS pools. See
          {manpage}`systemd.time(7)`.
        '';
      };

      pools = mkOption {
        default = [];
        type = types.listOf types.str;
        example = [ "tank" ];
        description = lib.mdDoc ''
          List of ZFS pools to periodically scrub. If empty, all pools
          will be scrubbed.
        '';
      };
    };

    services.zfs.expandOnBoot = mkOption {
      type = types.either (types.enum [ "disabled" "all" ]) (types.listOf types.str);
      default = "disabled";
      example = [ "tank" "dozer" ];
      description = lib.mdDoc ''
        After importing, expand each device in the specified pools.

        Set the value to the plain string "all" to expand all pools on boot:

            services.zfs.expandOnBoot = "all";

        or set the value to a list of pools to expand the disks of specific pools:

            services.zfs.expandOnBoot = [ "tank" "dozer" ];
      '';
    };

    services.zfs.zed = {
      enableMail = mkOption {
        type = types.bool;
        default = config.services.mail.sendmailSetuidWrapper != null;
        defaultText = literalExpression ''
          config.services.mail.sendmailSetuidWrapper != null
        '';
        description = mdDoc ''
          Whether to enable ZED's ability to send emails.
        '';
      };

      settings = mkOption {
        type = with types; attrsOf (oneOf [ str int bool (listOf str) ]);
        example = literalExpression ''
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
        description = lib.mdDoc ''
          ZFS Event Daemon /etc/zfs/zed.d/zed.rc content

          See
          {manpage}`zed(8)`
          for details on ZED and the scripts in /etc/zfs/zed.d to find the possible variables
        '';
      };
    };
  };

  ###### implementation

  config = mkMerge [
    (mkIf cfgZfs.enabled {
      assertions = [
        {
          assertion = cfgZfs.modulePackage.version == cfgZfs.package.version;
          message = "The kernel module and the userspace tooling versions are not matching, this is an unsupported usecase.";
        }
        {
          assertion = config.networking.hostId != null;
          message = "ZFS requires networking.hostId to be set";
        }
        {
          assertion = !cfgZfs.forceImportAll || cfgZfs.forceImportRoot;
          message = "If you enable boot.zfs.forceImportAll, you must also enable boot.zfs.forceImportRoot";
        }
        {
          assertion = cfgZfs.allowHibernation -> !cfgZfs.forceImportRoot && !cfgZfs.forceImportAll;
          message = "boot.zfs.allowHibernation while force importing is enabled will cause data corruption";
        }
        {
          assertion = !(elem "" allPools);
          message = ''
            Automatic pool detection found an empty pool name, which can't be used.
            Hint: for `fileSystems` entries with `fsType = zfs`, the `device` attribute
            should be a zfs dataset name, like `device = "pool/data/set"`.
            This error can be triggered by using an absolute path, such as `"/dev/disk/..."`.
          '';
        }
      ];

      boot = {
        kernelModules = [ "zfs" ];
        # https://github.com/openzfs/zfs/issues/260
        # https://github.com/openzfs/zfs/issues/12842
        # https://github.com/NixOS/nixpkgs/issues/106093
        kernelParams = lib.optionals (!config.boot.zfs.allowHibernation) [ "nohibernate" ];

        extraModulePackages = [
          (cfgZfs.modulePackage.override { inherit (cfgZfs) removeLinuxDRM; })
        ];
      };

      boot.initrd = mkIf inInitrd {
        # spl has been removed in ≥ 2.2.0.
        kernelModules = [ "zfs" ] ++ lib.optional (lib.versionOlder "2.2.0" version) "spl";
        extraUtilsCommands =
          mkIf (!config.boot.initrd.systemd.enable) ''
            copy_bin_and_libs ${cfgZfs.package}/sbin/zfs
            copy_bin_and_libs ${cfgZfs.package}/sbin/zdb
            copy_bin_and_libs ${cfgZfs.package}/sbin/zpool
          '';
        extraUtilsCommandsTest =
          mkIf (!config.boot.initrd.systemd.enable) ''
            $out/bin/zfs --help >/dev/null 2>&1
            $out/bin/zpool --help >/dev/null 2>&1
          '';
        postDeviceCommands = mkIf (!config.boot.initrd.systemd.enable) (concatStringsSep "\n" ([''
            ZFS_FORCE="${optionalString cfgZfs.forceImportRoot "-f"}"
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

            ${optionalString config.boot.initrd.clevis.enable (concatMapStringsSep "\n" (elem: "clevis decrypt < /etc/clevis/${elem}.jwe | zfs load-key ${elem}") (filter (p: (elemAt (splitString "/" p) 0) == pool) clevisDatasets))}

            ${if isBool cfgZfs.requestEncryptionCredentials
              then optionalString cfgZfs.requestEncryptionCredentials ''
                zfs load-key -a
              ''
              else concatMapStrings (fs: ''
                zfs load-key -- ${escapeShellArg fs}
              '') (filter (x: datasetToPool x == pool) cfgZfs.requestEncryptionCredentials)}
        '') rootPools)));

        # Systemd in stage 1
        systemd = mkIf config.boot.initrd.systemd.enable {
          packages = [cfgZfs.package];
          services = listToAttrs (map (pool: createImportService {
            inherit pool;
            systemd = config.boot.initrd.systemd.package;
            force = cfgZfs.forceImportRoot;
            prefix = "/sysroot";
          }) rootPools);
          targets.zfs-import.wantedBy = [ "zfs.target" ];
          targets.zfs.wantedBy = [ "initrd.target" ];
          extraBin = {
            zpool = "${cfgZfs.package}/sbin/zpool";
            zfs = "${cfgZfs.package}/sbin/zfs";
            awk = "${pkgs.gawk}/bin/awk";
          };
        };
      };

      systemd.shutdownRamfs.contents."/etc/systemd/system-shutdown/zpool".source = pkgs.writeShellScript "zpool-sync-shutdown" ''
        exec ${cfgZfs.package}/bin/zpool sync
      '';
      systemd.shutdownRamfs.storePaths = ["${cfgZfs.package}/bin/zpool"];

      # TODO FIXME See https://github.com/NixOS/nixpkgs/pull/99386#issuecomment-798813567. To not break people's bootloader and as probably not everybody would read release notes that thoroughly add inSystem.
      boot.loader.grub = mkIf (inInitrd || inSystem) {
        zfsSupport = true;
        zfsPackage = cfgZfs.package;
      };

      services.zfs.zed.settings = {
        ZED_EMAIL_PROG = mkIf cfgZED.enableMail (mkDefault (
          config.security.wrapperDir + "/" +
          config.services.mail.sendmailSetuidWrapper.program
        ));
        # subject in header for sendmail
        ZED_EMAIL_OPTS = mkIf cfgZED.enableMail (mkDefault "@ADDRESS@");

        PATH = lib.makeBinPath [
          cfgZfs.package
          pkgs.coreutils
          pkgs.curl
          pkgs.gawk
          pkgs.gnugrep
          pkgs.gnused
          pkgs.nettools
          pkgs.util-linux
        ];
      };

      # ZFS already has its own scheduler. Without this my(@Artturin) computer froze for a second when I nix build something.
      services.udev.extraRules = ''
        ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
      '';

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
        (file: { source = "${cfgZfs.package}/etc/${file}"; })
      // {
        "zfs/zed.d/zed.rc".text = zedConf;
        "zfs/zpool.d".source = "${cfgZfs.package}/etc/zfs/zpool.d/";
      };

      system.fsPackages = [ cfgZfs.package ]; # XXX: needed? zfs doesn't have (need) a fsck
      environment.systemPackages = [ cfgZfs.package ]
        ++ optional cfgSnapshots.enable autosnapPkg; # so the user can run the command to see flags

      services.udev.packages = [ cfgZfs.package ]; # to hook zvol naming, etc.
      systemd.packages = [ cfgZfs.package ];

      # Export kernel_neon_* symbols again.
      # This change is necessary until ZFS figures out a solution
      # with upstream or in their build system to fill the gap for
      # this symbol.
      # In the meantime, we restore what was once a working piece of code
      # in the kernel.
      boot.kernelPatches = lib.optional (cfgZfs.removeLinuxDRM && pkgs.stdenv.hostPlatform.system == "aarch64-linux") {
        name = "export-neon-symbols-as-gpl";
        patch = pkgs.fetchpatch {
          url = "https://github.com/torvalds/linux/commit/aaeca98456431a8d9382ecf48ac4843e252c07b3.patch";
          hash = "sha256-L2g4G1tlWPIi/QRckMuHDcdWBcKpObSWSRTvbHRIwIk=";
          revert = true;
        };
      };

      systemd.services = let
        createImportService' = pool: createImportService {
          inherit pool;
          systemd = config.systemd.package;
          force = cfgZfs.forceImportAll;
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
              ${cfgZfs.package}/sbin/zfs set nixos:shutdown-time="$(date)" "${pool}"
            '';
          };

        createZfsService = serv:
          nameValuePair serv {
            after = [ "systemd-modules-load.service" ];
            wantedBy = [ "zfs.target" ];
          };

      in listToAttrs (map createImportService' dataPools ++
                      map createSyncService allPools ++
                      map createZfsService [ "zfs-mount" "zfs-share" "zfs-zed" ]);

      systemd.targets.zfs-import.wantedBy = [ "zfs.target" ];

      systemd.targets.zfs.wantedBy = [ "multi-user.target" ];
    })

    (mkIf (cfgZfs.enabled && cfgExpandOnBoot != "disabled") {
      systemd.services."zpool-expand@" = {
        description = "Expand ZFS pools";
        after = [ "zfs.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        scriptArgs = "%i";
        path = [ cfgZfs.package ];

        script =  ''
          pool=$1

          echo "Expanding all devices for $pool."

          ${pkgs.zpool-auto-expand-partitions}/bin/zpool_part_disks --automatically-grow "$pool"
        '';
      };

      systemd.services."zpool-expand-pools" =
        let
          # Create a string, to be interpolated in a bash script
          # which enumerates all of the pools to expand.
          # If the `pools` option is `true`, we want to dynamically
          # expand every pool. Otherwise we want to enumerate
          # just the specifically provided list of pools.
          poolListProvider = if cfgExpandOnBoot == "all"
            then "$(zpool list -H -o name)"
            else lib.escapeShellArgs cfgExpandOnBoot;
        in
        {
          description = "Expand specified ZFS pools";
          wantedBy = [ "default.target" ];
          after = [ "zfs.target" ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };

          path = lib.optionals (cfgExpandOnBoot == "all") [ cfgZfs.package ];

          script = ''
            for pool in ${poolListProvider}; do
              systemctl start --no-block "zpool-expand@$pool"
            done
          '';
        };
    })

    (mkIf (cfgZfs.enabled && cfgSnapshots.enable) {
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

    (mkIf (cfgZfs.enabled && cfgScrub.enable) {
      systemd.services.zfs-scrub = {
        description = "ZFS pools scrubbing";
        after = [ "zfs-import.target" ];
        serviceConfig = {
          Type = "simple";
        };
        script = ''
          ${cfgZfs.package}/bin/zpool scrub -w ${
            if cfgScrub.pools != [] then
              (concatStringsSep " " cfgScrub.pools)
            else
              "$(${cfgZfs.package}/bin/zpool list -H -o name)"
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

    (mkIf (cfgZfs.enabled && cfgTrim.enable) {
      systemd.services.zpool-trim = {
        description = "ZFS pools trim";
        after = [ "zfs-import.target" ];
        path = [ cfgZfs.package ];
        startAt = cfgTrim.interval;
        # By default we ignore errors returned by the trim command, in case:
        # - HDDs are mixed with SSDs
        # - There is a SSDs in a pool that is currently trimmed.
        # - There are only HDDs and we would set the system in a degraded state
        serviceConfig.ExecStart = "${pkgs.runtimeShell} -c 'for pool in $(zpool list -H -o name); do zpool trim $pool;  done || true' ";
      };

      systemd.timers.zpool-trim.timerConfig.Persistent = "yes";
    })
  ];
}
