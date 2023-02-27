{ config, lib, pkgs, ... }: with lib;

# See http://christophe.varoqui.free.fr/usage.html and
# https://github.com/opensvc/multipath-tools/blob/master/multipath/multipath.conf.5

let
  cfg = config.services.multipath;

  indentLines = n: str: concatStringsSep "\n" (
    map (line: "${fixedWidthString n " " " "}${line}") (
      filter ( x: x != "" ) ( splitString "\n" str )
    )
  );

  addCheckDesc = desc: elemType: check: types.addCheck elemType check
    // { description = "${elemType.description} (with check: ${desc})"; };
  hexChars = stringToCharacters "0123456789abcdef";
  isHexString = s: all (c: elem c hexChars) (stringToCharacters (toLower s));
  hexStr = addCheckDesc "hexadecimal string" types.str isHexString;

in {

  options.services.multipath = with types; {

    enable = mkEnableOption (lib.mdDoc "the device mapper multipath (DM-MP) daemon");

    package = mkOption {
      type = package;
      description = lib.mdDoc "multipath-tools package to use";
      default = pkgs.multipath-tools;
      defaultText = lib.literalExpression "pkgs.multipath-tools";
    };

    devices = mkOption {
      default = [ ];
      example = literalExpression ''
        [
          {
            vendor = "\"COMPELNT\"";
            product = "\"Compellent Vol\"";
            path_checker = "tur";
            no_path_retry = "queue";
            max_sectors_kb = 256;
          }, ...
        ]
      '';
      description = lib.mdDoc ''
        This option allows you to define arrays for use in multipath
        groups.
      '';
      type = listOf (submodule {
        options = {

          vendor = mkOption {
            type = str;
            example = "COMPELNT";
            description = lib.mdDoc "Regular expression to match the vendor name";
          };

          product = mkOption {
            type = str;
            example = "Compellent Vol";
            description = lib.mdDoc "Regular expression to match the product name";
          };

          revision = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "Regular expression to match the product revision";
          };

          product_blacklist = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "Products with the given vendor matching this string are blacklisted";
          };

          alias_prefix = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "The user_friendly_names prefix to use for this device type, instead of the default mpath";
          };

          vpd_vendor = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "The vendor specific vpd page information, using the vpd page abbreviation";
          };

          hardware_handler = mkOption {
            type = nullOr (enum [ "emc" "rdac" "hp_sw" "alua" "ana" ]);
            default = null;
            description = lib.mdDoc "The hardware handler to use for this device type";
          };

          # Optional arguments
          path_grouping_policy = mkOption {
            type = nullOr (enum [ "failover" "multibus" "group_by_serial" "group_by_prio" "group_by_node_name" ]);
            default = null; # real default: "failover"
            description = lib.mdDoc "The default path grouping policy to apply to unspecified multipaths";
          };

          uid_attribute = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "The udev attribute providing a unique path identifier (WWID)";
          };

          getuid_callout = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc ''
              (Superseded by uid_attribute) The default program and args to callout
              to obtain a unique path identifier. Should be specified with an absolute path.
            '';
          };

          path_selector = mkOption {
            type = nullOr (enum [
              ''"round-robin 0"''
              ''"queue-length 0"''
              ''"service-time 0"''
              ''"historical-service-time 0"''
            ]);
            default = null; # real default: "service-time 0"
            description = lib.mdDoc "The default path selector algorithm to use; they are offered by the kernel multipath target";
          };

          path_checker = mkOption {
            type = enum [ "readsector0" "tur" "emc_clariion" "hp_sw" "rdac" "directio" "cciss_tur" "none" ];
            default = "tur";
            description = lib.mdDoc "The default method used to determine the paths state";
          };

          prio = mkOption {
            type = nullOr (enum [
              "none" "const" "sysfs" "emc" "alua" "ontap" "rdac" "hp_sw" "hds"
              "random" "weightedpath" "path_latency" "ana" "datacore" "iet"
            ]);
            default = null; # real default: "const"
            description = lib.mdDoc "The name of the path priority routine";
          };

          prio_args = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "Arguments to pass to to the prio function";
          };

          features = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "Specify any device-mapper features to be used";
          };

          failback = mkOption {
            type = nullOr str;
            default = null; # real default: "manual"
            description = lib.mdDoc "Tell multipathd how to manage path group failback. Quote integers as strings";
          };

          rr_weight = mkOption {
            type = nullOr (enum [ "priorities" "uniform" ]);
            default = null; # real default: "uniform"
            description = lib.mdDoc ''
              If set to priorities the multipath configurator will assign path weights
              as "path prio * rr_min_io".
            '';
          };

          no_path_retry = mkOption {
            type = nullOr str;
            default = null; # real default: "fail"
            description = lib.mdDoc "Specify what to do when all paths are down. Quote integers as strings";
          };

          rr_min_io = mkOption {
            type = nullOr int;
            default = null; # real default: 1000
            description = lib.mdDoc ''
              Number of I/O requests to route to a path before switching to the next in the
              same path group. This is only for Block I/O (BIO) based multipath and
              only apply to round-robin path_selector.
            '';
          };

          rr_min_io_rq = mkOption {
            type = nullOr int;
            default = null; # real default: 1
            description = lib.mdDoc ''
              Number of I/O requests to route to a path before switching to the next in the
              same path group. This is only for Request based multipath and
              only apply to round-robin path_selector.
            '';
          };

          fast_io_fail_tmo = mkOption {
            type = nullOr str;
            default = null; # real default: 5
            description = lib.mdDoc ''
              Specify the number of seconds the SCSI layer will wait after a problem has been
              detected on a FC remote port before failing I/O to devices on that remote port.
              This should be smaller than dev_loss_tmo. Setting this to "off" will disable
              the timeout. Quote integers as strings.
            '';
          };

          dev_loss_tmo = mkOption {
            type = nullOr str;
            default = null; # real default: 600
            description = lib.mdDoc ''
              Specify the number of seconds the SCSI layer will wait after a problem has
              been detected on a FC remote port before removing it from the system. This
              can be set to "infinity" which sets it to the max value of 2147483647
              seconds, or 68 years. It will be automatically adjusted to the overall
              retry interval no_path_retry * polling_interval
              if a number of retries is given with no_path_retry and the
              overall retry interval is longer than the specified dev_loss_tmo value.
              The Linux kernel will cap this value to 600 if fast_io_fail_tmo
              is not set.
            '';
          };

          flush_on_last_del = mkOption {
            type = nullOr (enum [ "yes" "no" ]);
            default = null; # real default: "no"
            description = lib.mdDoc ''
              If set to "yes" multipathd will disable queueing when the last path to a
              device has been deleted.
            '';
          };

          user_friendly_names = mkOption {
            type = nullOr (enum [ "yes" "no" ]);
            default = null; # real default: "no"
            description = lib.mdDoc ''
              If set to "yes", using the bindings file /etc/multipath/bindings
              to assign a persistent and unique alias to the multipath, in the
              form of mpath. If set to "no" use the WWID as the alias. In either
              case this be will be overridden by any specific aliases in the
              multipaths section.
            '';
          };

          detect_prio = mkOption {
            type = nullOr (enum [ "yes" "no" ]);
            default = null; # real default: "yes"
            description = lib.mdDoc ''
              If set to "yes", multipath will try to detect if the device supports
              SCSI-3 ALUA. If so, the device will automatically use the sysfs
              prioritizer if the required sysf attributes access_state and
              preferred_path are supported, or the alua prioritizer if not. If set
              to "no", the prioritizer will be selected as usual.
            '';
          };

          detect_checker = mkOption {
            type = nullOr (enum [ "yes" "no" ]);
            default = null; # real default: "yes"
            description = lib.mdDoc ''
              If set to "yes", multipath will try to detect if the device supports
              SCSI-3 ALUA. If so, the device will automatically use the tur checker.
              If set to "no", the checker will be selected as usual.
            '';
          };

          deferred_remove = mkOption {
            type = nullOr (enum [ "yes" "no" ]);
            default = null; # real default: "no"
            description = lib.mdDoc ''
              If set to "yes", multipathd will do a deferred remove instead of a
              regular remove when the last path device has been deleted. This means
              that if the multipath device is still in use, it will be freed when
              the last user closes it. If path is added to the multipath device
              before the last user closes it, the deferred remove will be canceled.
            '';
          };

          san_path_err_threshold = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc ''
              If set to a value greater than 0, multipathd will watch paths and check
              how many times a path has been failed due to errors.If the number of
              failures on a particular path is greater then the san_path_err_threshold,
              then the path will not reinstate till san_path_err_recovery_time. These
              path failures should occur within a san_path_err_forget_rate checks, if
              not we will consider the path is good enough to reinstantate.
            '';
          };

          san_path_err_forget_rate = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc ''
              If set to a value greater than 0, multipathd will check whether the path
              failures has exceeded the san_path_err_threshold within this many checks
              i.e san_path_err_forget_rate. If so we will not reinstante the path till
              san_path_err_recovery_time.
            '';
          };

          san_path_err_recovery_time = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc ''
              If set to a value greater than 0, multipathd will make sure that when
              path failures has exceeded the san_path_err_threshold within
              san_path_err_forget_rate then the path will be placed in failed state
              for san_path_err_recovery_time duration. Once san_path_err_recovery_time
              has timeout we will reinstante the failed path. san_path_err_recovery_time
              value should be in secs.
            '';
          };

          marginal_path_err_sample_time = mkOption {
            type = nullOr int;
            default = null;
            description = lib.mdDoc "One of the four parameters of supporting path check based on accounting IO error such as intermittent error";
          };

          marginal_path_err_rate_threshold = mkOption {
            type = nullOr int;
            default = null;
            description = lib.mdDoc "The error rate threshold as a permillage (1/1000)";
          };

          marginal_path_err_recheck_gap_time = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "One of the four parameters of supporting path check based on accounting IO error such as intermittent error";
          };

          marginal_path_double_failed_time = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "One of the four parameters of supporting path check based on accounting IO error such as intermittent error";
          };

          delay_watch_checks = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "This option is deprecated, and mapped to san_path_err_forget_rate";
          };

          delay_wait_checks = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "This option is deprecated, and mapped to san_path_err_recovery_time";
          };

          skip_kpartx = mkOption {
            type = nullOr (enum [ "yes" "no" ]);
            default = null; # real default: "no"
            description = lib.mdDoc "If set to yes, kpartx will not automatically create partitions on the device";
          };

          max_sectors_kb = mkOption {
            type = nullOr int;
            default = null;
            description = lib.mdDoc "Sets the max_sectors_kb device parameter on all path devices and the multipath device to the specified value";
          };

          ghost_delay = mkOption {
            type = nullOr int;
            default = null;
            description = lib.mdDoc "Sets the number of seconds that multipath will wait after creating a device with only ghost paths before marking it ready for use in systemd";
          };

          all_tg_pt = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "Set the 'all targets ports' flag when registering keys with mpathpersist";
          };

        };
      });
    };

    defaults = mkOption {
      type = nullOr str;
      default = null;
      description = lib.mdDoc ''
        This section defines default values for attributes which are used
        whenever no values are given in the appropriate device or multipath
        sections.
      '';
    };

    blacklist = mkOption {
      type = nullOr str;
      default = null;
      description = lib.mdDoc ''
        This section defines which devices should be excluded from the
        multipath topology discovery.
      '';
    };

    blacklist_exceptions = mkOption {
      type = nullOr str;
      default = null;
      description = lib.mdDoc ''
        This section defines which devices should be included in the
        multipath topology discovery, despite being listed in the
        blacklist section.
      '';
    };

    overrides = mkOption {
      type = nullOr str;
      default = null;
      description = lib.mdDoc ''
        This section defines values for attributes that should override the
        device-specific settings for all devices.
      '';
    };

    extraConfig = mkOption {
      type = nullOr str;
      default = null;
      description = lib.mdDoc "Lines to append to default multipath.conf";
    };

    extraConfigFile = mkOption {
      type = nullOr str;
      default = null;
      description = lib.mdDoc "Append an additional file's contents to /etc/multipath.conf";
    };

    pathGroups = mkOption {
      example = literalExpression ''
        [
          {
            wwid = "360080e500043b35c0123456789abcdef";
            alias = 10001234;
            array = "bigarray.example.com";
            fsType = "zfs"; # optional
            options = "ro"; # optional
          }, ...
        ]
      '';
      description = lib.mdDoc ''
        This option allows you to define multipath groups as described
        in http://christophe.varoqui.free.fr/usage.html.
      '';
      type = listOf (submodule {
        options = {

          alias = mkOption {
            type = int;
            example = 1001234;
            description = lib.mdDoc "The name of the multipath device";
          };

          wwid = mkOption {
            type = hexStr;
            example = "360080e500043b35c0123456789abcdef";
            description = lib.mdDoc "The identifier for the multipath device";
          };

          array = mkOption {
            type = str;
            default = null;
            example = "bigarray.example.com";
            description = lib.mdDoc "The DNS name of the storage array";
          };

          fsType = mkOption {
            type = nullOr str;
            default = null;
            example = "zfs";
            description = lib.mdDoc "Type of the filesystem";
          };

          options = mkOption {
            type = nullOr str;
            default = null;
            example = "ro";
            description = lib.mdDoc "Options used to mount the file system";
          };

        };
      });
    };

  };

  config = mkIf cfg.enable {
    environment.etc."multipath.conf".text =
      let
        inherit (cfg) defaults blacklist blacklist_exceptions overrides;

        mkDeviceBlock = cfg: let
          nonNullCfg = lib.filterAttrs (k: v: v != null) cfg;
          attrs = lib.mapAttrsToList (name: value: "  ${name} ${toString value}") nonNullCfg;
        in ''
          device {
          ${lib.concatStringsSep "\n" attrs}
          }
        '';
        devices = lib.concatMapStringsSep "\n" mkDeviceBlock cfg.devices;

        mkMultipathBlock = m: ''
          multipath {
            wwid ${m.wwid}
            alias ${toString m.alias}
          }
        '';
        multipaths = lib.concatMapStringsSep "\n" mkMultipathBlock cfg.pathGroups;

      in ''
        devices {
        ${indentLines 2 devices}
        }

        ${optionalString (!isNull defaults) ''
          defaults {
          ${indentLines 2 defaults}
          }
        ''}
        ${optionalString (!isNull blacklist) ''
          blacklist {
          ${indentLines 2 blacklist}
          }
        ''}
        ${optionalString (!isNull blacklist_exceptions) ''
          blacklist_exceptions {
          ${indentLines 2 blacklist_exceptions}
          }
        ''}
        ${optionalString (!isNull overrides) ''
          overrides {
          ${indentLines 2 overrides}
          }
        ''}
        multipaths {
        ${indentLines 2 multipaths}
        }
      '';

    systemd.packages = [ cfg.package ];

    environment.systemPackages = [ cfg.package ];
    boot.kernelModules = [ "dm-multipath" "dm-service-time" ];

    # We do not have systemd in stage-1 boot so must invoke `multipathd`
    # with the `-1` argument which disables systemd calls. Invoke `multipath`
    # to display the multipath mappings in the output of `journalctl -b`.
    boot.initrd.kernelModules = [ "dm-multipath" "dm-service-time" ];
    boot.initrd.postDeviceCommands = ''
      modprobe -a dm-multipath dm-service-time
      multipathd -s
      (set -x && sleep 1 && multipath -ll)
    '';
  };
}
