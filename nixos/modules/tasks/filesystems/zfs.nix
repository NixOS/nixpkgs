{ config, lib, options, pkgs, utils, ... }:
#
# TODO: zfs tunables

let

  cfgZfs = config.boot.zfs;
  cfgExpandOnBoot = config.services.zfs.expandOnBoot;
  cfgSnapshots = config.services.zfs.autoSnapshot;
  cfgSnapFlags = cfgSnapshots.flags;
  cfgScrub = config.services.zfs.autoScrub;
  cfgTrim = config.services.zfs.trim;
  cfgZED = config.services.zfs.zed;

  selectModulePackage = package: config.boot.kernelPackages.${package.kernelModuleAttribute};
  clevisDatasets = lib.attrNames (lib.filterAttrs (device: _: lib.any (e: e.fsType == "zfs" && (utils.fsNeededForBoot e) && (e.device == device || lib.hasPrefix "${device}/" e.device)) config.system.build.fileSystems) config.boot.initrd.clevis.devices);

  inInitrd = config.boot.initrd.supportedFilesystems.zfs or false;
  inSystem = config.boot.supportedFilesystems.zfs or false;

  autosnapPkg = pkgs.zfstools.override {
    zfs = cfgZfs.package;
  };

  zfsAutoSnap = "${autosnapPkg}/bin/zfs-auto-snapshot";

  datasetToPool = x: lib.elemAt (lib.splitString "/" x) 0;

  fsToPool = fs: datasetToPool fs.device;

  zfsFilesystems = lib.filter (x: x.fsType == "zfs") config.system.build.fileSystems;

  allPools = lib.unique ((map fsToPool zfsFilesystems) ++ cfgZfs.extraPools);

  rootPools = lib.unique (map fsToPool (lib.filter utils.fsNeededForBoot zfsFilesystems));

  dataPools = lib.unique (lib.filter (pool: !(lib.elem pool rootPools)) allPools);

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
  importLib = {zpoolCmd, awkCmd, pool}: let
    devNodes = if pool != null && cfgZfs.pools ? ${pool} then cfgZfs.pools.${pool}.devNodes else cfgZfs.devNodes;
  in ''
    # shellcheck disable=SC2013
    for o in $(cat /proc/cmdline); do
      case $o in
        zfs_force|zfs_force=1|zfs_force=y)
          ZFS_FORCE="-f"
          ;;
      esac
    done
    poolReady() {
      pool="$1"
      state="$("${zpoolCmd}" import -d "${devNodes}" 2>/dev/null | "${awkCmd}" "/pool: $pool/ { found = 1 }; /state:/ { if (found == 1) { print \$2; exit } }; END { if (found == 0) { print \"MISSING\" } }")"
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
      # shellcheck disable=SC2086
      "${zpoolCmd}" import -d "${devNodes}" -N $ZFS_FORCE "$pool"
    }
  '';

  getPoolFilesystems = pool:
    lib.filter (x: x.fsType == "zfs" && (fsToPool x) == pool) config.system.build.fileSystems;

  getPoolMounts = prefix: pool:
    let
      poolFSes = getPoolFilesystems pool;

      # Remove the "/" suffix because even though most mountpoints
      # won't have it, the "/" mountpoint will, and we can't have the
      # trailing slash in "/sysroot/" in stage 1.
      mountPoint = fs: utils.escapeSystemdPath (prefix + (lib.removeSuffix "/" fs.mountPoint));

      hasUsr = lib.any (fs: fs.mountPoint == "/usr") poolFSes;
    in
      map (x: "${mountPoint x}.mount") poolFSes
      ++ lib.optional hasUsr "sysusr-usr.mount";

  getKeyLocations = pool: if lib.isBool cfgZfs.requestEncryptionCredentials then {
    hasKeys = cfgZfs.requestEncryptionCredentials;
    command = "${cfgZfs.package}/sbin/zfs list -rHo name,keylocation,keystatus -t volume,filesystem ${pool}";
  } else let
    keys = lib.filter (x: datasetToPool x == pool) cfgZfs.requestEncryptionCredentials;
  in {
    hasKeys = keys != [];
    command = "${cfgZfs.package}/sbin/zfs list -Ho name,keylocation,keystatus -t volume,filesystem ${toString keys}";
  };

  createImportService = { pool, systemd, force, prefix ? "" }:
    lib.nameValuePair "zfs-import-${pool}" {
      description = "Import ZFS pool \"${pool}\"";
      # We wait for systemd-udev-settle to ensure devices are available,
      # but don't *require* it, because mounts shouldn't be killed if it's stopped.
      # In the future, hopefully someone will complete this:
      # https://github.com/zfsonlinux/zfs/pull/4943
      wants = [ "systemd-udev-settle.service" ] ++ lib.optional (config.boot.initrd.clevis.useTang) "network-online.target";
      after = [
        "systemd-udev-settle.service"
        "systemd-modules-load.service"
        "systemd-ask-password-console.service"
      ] ++ lib.optional (config.boot.initrd.clevis.useTang) "network-online.target";
      requiredBy = let
        noauto = lib.all (fs: lib.elem "noauto" fs.options) (getPoolFilesystems pool);
      in getPoolMounts prefix pool ++ lib.optional (!noauto) "zfs-import.target";
      before = getPoolMounts prefix pool ++ [ "shutdown.target" "zfs-import.target" ];
      conflicts = [ "shutdown.target" ];
      unitConfig = {
        DefaultDependencies = "no";
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      environment.ZFS_FORCE = lib.optionalString force "-f";
      script = let
        keyLocations = getKeyLocations pool;
      in (importLib {
        # See comments at importLib definition.
        zpoolCmd = "${cfgZfs.package}/sbin/zpool";
        awkCmd = "${pkgs.gawk}/bin/awk";
        inherit pool;
      }) + ''
        if ! poolImported "${pool}"; then
          echo -n "importing ZFS pool \"${pool}\"..."
          # Loop across the import until it succeeds, because the devices needed may not be discovered yet.
          for _ in $(seq 1 60); do
            poolReady "${pool}" && poolImport "${pool}" && break
            sleep 1
          done
          poolImported "${pool}" || poolImport "${pool}"  # Try one last time, e.g. to import a degraded pool.
        fi
        if poolImported "${pool}"; then
        ${lib.optionalString config.boot.initrd.clevis.enable (lib.concatMapStringsSep "\n" (elem: "clevis decrypt < /etc/clevis/${elem}.jwe | zfs load-key ${elem} || true ") (lib.filter (p: (lib.elemAt (lib.splitString "/" p) 0) == pool) clevisDatasets))}


          ${lib.optionalString keyLocations.hasKeys ''
            ${keyLocations.command} | while IFS=$'\t' read -r ds kl ks; do
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

  zedConf = lib.generators.toKeyValue {
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString = v:
        if lib.isInt           v then toString v
        else if lib.isString   v then "\"${v}\""
        else if true  ==   v then "1"
        else if false ==   v then "0"
        else if lib.isList     v then "\"" + (lib.concatStringsSep " " v) + "\""
        else lib.err "this value is" (toString v);
    } "=";
  } cfgZED.settings;
in

{

  imports = [
    (lib.mkRemovedOptionModule [ "boot" "zfs" "enableLegacyCrypto" ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "boot" "zfs" "enableUnstable" ] "Instead set `boot.zfs.package = pkgs.zfs_unstable;`")
  ];

  ###### interface

  options = {
    boot.zfs = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.zfs;
        defaultText = lib.literalExpression "pkgs.zfs";
        description = "Configured ZFS userland tools package.";
      };

      modulePackage = lib.mkOption {
        internal = true; # It is supposed to be selected automatically, but can be overridden by expert users.
        default = selectModulePackage cfgZfs.package;
        type = lib.types.package;
        description = "Configured ZFS kernel module package.";
      };

      enabled = lib.mkOption {
        readOnly = true;
        type = lib.types.bool;
        default = inInitrd || inSystem;
        defaultText = lib.literalMD "`true` if ZFS filesystem support is enabled";
        description = "True if ZFS filesystem support is enabled";
      };

      allowHibernation = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Allow hibernation support, this may be a unsafe option depending on your
          setup. Make sure to NOT use Swap on ZFS.
        '';
      };

      extraPools = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = [ "tank" "data" ];
        description = ''
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

      devNodes = lib.mkOption {
        type = lib.types.path;
        default = "/dev/disk/by-id";
        description = ''
          Name of directory from which to import ZFS device, this is passed to `zpool import`
          as the value of the `-d` option.

          For guidance on choosing this value, see
          [the ZFS documentation](https://openzfs.github.io/openzfs-docs/Project%20and%20Community/FAQ.html#selecting-dev-names-when-creating-a-pool-linux).
        '';
      };

      forceImportRoot = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
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

      forceImportAll = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Forcibly import all ZFS pool(s).

          If you set this option to `false` and NixOS subsequently fails to
          import your non-root ZFS pool(s), you should manually import each pool with
          "zpool import -f \<pool-name\>", and then reboot. You should only need to do
          this once.
        '';
      };

      requestEncryptionCredentials = lib.mkOption {
        type = lib.types.either lib.types.bool (lib.types.listOf lib.types.str);
        default = true;
        example = [ "tank" "data" ];
        description = ''
          If true on import encryption keys or passwords for all encrypted datasets
          are requested. To only decrypt selected datasets supply a list of dataset
          names instead. For root pools the encryption key can be supplied via both
          an interactive prompt (keylocation=prompt) and from a file (keylocation=file://).
        '';
      };

      passwordTimeout = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = ''
          Timeout in seconds to wait for password entry for decrypt at boot.

          Defaults to 0, which waits forever.
        '';
      };

      pools = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            devNodes = lib.mkOption {
              type = lib.types.path;
              default = cfgZfs.devNodes;
              defaultText = "config.boot.zfs.devNodes";
              description = options.boot.zfs.devNodes.description;
            };
          };
        });
        default = { };
        description = ''
          Configuration for individual pools to override global defaults.
        '';
      };

      removeLinuxDRM = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Patch the kernel to change symbols needed by ZFS from
          EXPORT_SYMBOL_GPL to EXPORT_SYMBOL.

          Currently has no effect, but may again in future if a kernel
          update breaks ZFS due to symbols being newly changed to GPL.
        '';
      };
    };

    services.zfs.autoSnapshot = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable the (OpenSolaris-compatible) ZFS auto-snapshotting service.
          Note that you must set the `com.sun:auto-snapshot`
          property to `true` on all datasets which you wish
          to auto-snapshot.

          You can override a child dataset to use, or not use auto-snapshotting
          by setting its flag with the given interval:
          `zfs set com.sun:auto-snapshot:weekly=false DATASET`
        '';
      };

      flags = lib.mkOption {
        default = "-k -p";
        example = "-k -p --utc";
        type = lib.types.str;
        description = ''
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

      frequent = lib.mkOption {
        default = 4;
        type = lib.types.int;
        description = ''
          Number of frequent (15-minute) auto-snapshots that you wish to keep.
        '';
      };

      hourly = lib.mkOption {
        default = 24;
        type = lib.types.int;
        description = ''
          Number of hourly auto-snapshots that you wish to keep.
        '';
      };

      daily = lib.mkOption {
        default = 7;
        type = lib.types.int;
        description = ''
          Number of daily auto-snapshots that you wish to keep.
        '';
      };

      weekly = lib.mkOption {
        default = 4;
        type = lib.types.int;
        description = ''
          Number of weekly auto-snapshots that you wish to keep.
        '';
      };

      monthly = lib.mkOption {
        default = 12;
        type = lib.types.int;
        description = ''
          Number of monthly auto-snapshots that you wish to keep.
        '';
      };
    };

    services.zfs.trim = {
      enable = lib.mkOption {
        description = "Whether to enable periodic TRIM on all ZFS pools.";
        default = true;
        example = false;
        type = lib.types.bool;
      };

      interval = lib.mkOption {
        default = "weekly";
        type = lib.types.str;
        example = "daily";
        description = ''
          How often we run trim. For most desktop and server systems
          a sufficient trimming frequency is once a week.

          The format is described in
          {manpage}`systemd.time(7)`.
        '';
      };

      randomizedDelaySec = lib.mkOption {
        default = "6h";
        type = lib.types.str;
        example = "12h";
        description = ''
          Add a randomized delay before each ZFS trim.
          The delay will be chosen between zero and this value.
          This value must be a time span in the format specified by
          {manpage}`systemd.time(7)`
        '';
      };
    };

    services.zfs.autoScrub = {
      enable = lib.mkEnableOption "periodic scrubbing of ZFS pools";

      interval = lib.mkOption {
        default = "monthly";
        type = lib.types.str;
        example = "quarterly";
        description = ''
          Systemd calendar expression when to scrub ZFS pools. See
          {manpage}`systemd.time(7)`.
        '';
      };

      randomizedDelaySec = lib.mkOption {
        default = "6h";
        type = lib.types.str;
        example = "12h";
        description = ''
          Add a randomized delay before each ZFS autoscrub.
          The delay will be chosen between zero and this value.
          This value must be a time span in the format specified by
          {manpage}`systemd.time(7)`
        '';
      };

      pools = lib.mkOption {
        default = [];
        type = lib.types.listOf lib.types.str;
        example = [ "tank" ];
        description = ''
          List of ZFS pools to periodically scrub. If empty, all pools
          will be scrubbed.
        '';
      };
    };

    services.zfs.expandOnBoot = lib.mkOption {
      type = lib.types.either (lib.types.enum [ "disabled" "all" ]) (lib.types.listOf lib.types.str);
      default = "disabled";
      example = [ "tank" "dozer" ];
      description = ''
        After importing, expand each device in the specified pools.

        Set the value to the plain string "all" to expand all pools on boot:

            services.zfs.expandOnBoot = "all";

        or set the value to a list of pools to expand the disks of specific pools:

            services.zfs.expandOnBoot = [ "tank" "dozer" ];
      '';
    };

    services.zfs.zed = {
      enableMail = lib.mkOption {
        type = lib.types.bool;
        default = config.services.mail.sendmailSetuidWrapper != null;
        defaultText = lib.literalExpression ''
          config.services.mail.sendmailSetuidWrapper != null
        '';
        description = ''
          Whether to enable ZED's ability to send emails.
        '';
      };

      settings = lib.mkOption {
        type = let t = lib.types; in t.attrsOf (t.oneOf [ t.str t.int t.bool (t.listOf t.str) ]);
        example = lib.literalExpression ''
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
          {manpage}`zed(8)`
          for details on ZED and the scripts in /etc/zfs/zed.d to find the possible variables
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkMerge [
    (lib.mkIf cfgZfs.enabled {
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
          assertion = !(lib.elem "" allPools);
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
          cfgZfs.modulePackage
        ];
      };

      boot.initrd = lib.mkIf inInitrd {
        kernelModules = [ "zfs" ];
        extraUtilsCommands =
          lib.mkIf (!config.boot.initrd.systemd.enable) ''
            copy_bin_and_libs ${cfgZfs.package}/sbin/zfs
            copy_bin_and_libs ${cfgZfs.package}/sbin/zdb
            copy_bin_and_libs ${cfgZfs.package}/sbin/zpool
            copy_bin_and_libs ${cfgZfs.package}/lib/udev/vdev_id
            copy_bin_and_libs ${cfgZfs.package}/lib/udev/zvol_id
          '';
        extraUtilsCommandsTest =
          lib.mkIf (!config.boot.initrd.systemd.enable) ''
            $out/bin/zfs --help >/dev/null 2>&1
            $out/bin/zpool --help >/dev/null 2>&1
          '';
        postResumeCommands = lib.mkIf (!config.boot.initrd.systemd.enable) (lib.concatStringsSep "\n" ([''
            ZFS_FORCE="${lib.optionalString cfgZfs.forceImportRoot "-f"}"
          ''] ++ [(importLib {
            # See comments at importLib definition.
            zpoolCmd = "zpool";
            awkCmd = "awk";
            pool = null;
          })] ++ (map (pool: ''
            echo -n "importing root ZFS pool \"${pool}\"..."
            # Loop across the import until it succeeds, because the devices needed may not be discovered yet.
            if ! poolImported "${pool}"; then
              for _ in $(seq 1 60); do
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

            ${lib.optionalString config.boot.initrd.clevis.enable (lib.concatMapStringsSep "\n" (elem: "clevis decrypt < /etc/clevis/${elem}.jwe | zfs load-key ${elem}") (lib.filter (p: (lib.elemAt (lib.splitString "/" p) 0) == pool) clevisDatasets))}

            ${if lib.isBool cfgZfs.requestEncryptionCredentials
              then lib.optionalString cfgZfs.requestEncryptionCredentials ''
                zfs load-key -a
              ''
              else lib.concatMapStrings (fs: ''
                zfs load-key -- ${lib.escapeShellArg fs}
              '') (lib.filter (x: datasetToPool x == pool) cfgZfs.requestEncryptionCredentials)}
        '') rootPools)));

        # Systemd in stage 1
        systemd = lib.mkIf config.boot.initrd.systemd.enable {
          packages = [cfgZfs.package];
          services = lib.listToAttrs (map (pool: createImportService {
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
          storePaths = [
            "${cfgZfs.package}/lib/udev/vdev_id"
            "${cfgZfs.package}/lib/udev/zvol_id"
          ];
        };
        services.udev.packages = [cfgZfs.package]; # to hook zvol naming, in stage 1
      };

      systemd.shutdownRamfs.contents."/etc/systemd/system-shutdown/zpool".source = pkgs.writeShellScript "zpool-sync-shutdown" ''
        exec ${cfgZfs.package}/bin/zpool sync
      '';
      systemd.shutdownRamfs.storePaths = ["${cfgZfs.package}/bin/zpool"];

      # TODO FIXME See https://github.com/NixOS/nixpkgs/pull/99386#issuecomment-798813567. To not break people's bootloader and as probably not everybody would read release notes that thoroughly add inSystem.
      boot.loader.grub = lib.mkIf (inInitrd || inSystem) {
        zfsSupport = true;
        zfsPackage = cfgZfs.package;
      };

      services.zfs.zed.settings = {
        ZED_EMAIL_PROG = lib.mkIf cfgZED.enableMail (lib.mkDefault (
          config.security.wrapperDir + "/" +
          config.services.mail.sendmailSetuidWrapper.program
        ));
        # subject in header for sendmail
        ZED_EMAIL_OPTS = lib.mkIf cfgZED.enableMail (lib.mkDefault "@ADDRESS@");

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

      environment.etc = lib.genAttrs
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
        ++ lib.optional cfgSnapshots.enable autosnapPkg; # so the user can run the command to see flags

      services.udev.packages = [ cfgZfs.package ]; # to hook zvol naming, etc.
      systemd.packages = [ cfgZfs.package ];

      systemd.services = let
        createImportService' = pool: createImportService {
          inherit pool;
          systemd = config.systemd.package;
          force = cfgZfs.forceImportAll;
        };

        # This forces a sync of any ZFS pools prior to poweroff, even if they're set
        # to sync=disabled.
        createSyncService = pool:
          lib.nameValuePair "zfs-sync-${pool}" {
            description = "Sync ZFS pool \"${pool}\"";
            wantedBy = [ "shutdown.target" ];
            before = [ "final.target" ];
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
          lib.nameValuePair serv {
            after = [ "systemd-modules-load.service" ];
            wantedBy = [ "zfs.target" ];
          };

      in lib.listToAttrs (map createImportService' dataPools ++
                      map createSyncService allPools ++
                      map createZfsService [ "zfs-mount" "zfs-share" "zfs-zed" ]);

      systemd.targets.zfs-import.wantedBy = [ "zfs.target" ];

      systemd.targets.zfs.wantedBy = [ "multi-user.target" ];
    })

    (lib.mkIf (cfgZfs.enabled && cfgExpandOnBoot != "disabled") {
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

    (lib.mkIf (cfgZfs.enabled && cfgSnapshots.enable) {
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

    (lib.mkIf (cfgZfs.enabled && cfgScrub.enable) {
      systemd.services.zfs-scrub = {
        description = "ZFS pools scrubbing";
        after = [ "zfs-import.target" ];
        serviceConfig = {
          Type = "simple";
        };
        script = ''
          # shellcheck disable=SC2046
          ${cfgZfs.package}/bin/zpool scrub -w ${
            if cfgScrub.pools != [] then
              (lib.concatStringsSep " " cfgScrub.pools)
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
          RandomizedDelaySec = cfgScrub.randomizedDelaySec;
        };
      };
    })

    (lib.mkIf (cfgZfs.enabled && cfgTrim.enable) {
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

      systemd.timers.zpool-trim.timerConfig = {
        Persistent = "yes";
        RandomizedDelaySec = cfgTrim.randomizedDelaySec;
      };
    })
  ];
}
