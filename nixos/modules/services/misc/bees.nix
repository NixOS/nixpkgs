{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.beesd;

  logLevels = {
    emerg = 0;
    alert = 1;
    crit = 2;
    err = 3;
    warning = 4;
    notice = 5;
    info = 6;
    debug = 7;
  };

  fsOptions = with lib.types; {
    options.spec = lib.mkOption {
      type = str;
      description = ''
        Description of how to identify the filesystem to be duplicated by this
        instance of bees. Note that deduplication crosses subvolumes; one must
        not configure multiple instances for subvolumes of the same filesystem
        (or block devices which are part of the same filesystem), but only for
        completely independent btrfs filesystems.

        This must be in a format usable by findmnt; that could be a key=value
        pair, or a bare path to a mount point.
        Using bare paths will allow systemd to start the beesd service only
        after mounting the associated path.
      '';
      example = "LABEL=MyBulkDataDrive";
    };
    options.hashTableSizeMB = lib.mkOption {
      type = lib.types.addCheck lib.types.int (n: lib.mod n 16 == 0);
      default = 1024; # 1GB; default from upstream beesd script
      description = ''
        Hash table size in MB; must be a multiple of 16.

        A larger ratio of index size to storage size means smaller blocks of
        duplicate content are recognized.

        If you have 1TB of data, a 4GB hash table (which is to say, a value of
        4096) will permit 4KB extents (the smallest possible size) to be
        recognized, whereas a value of 1024 -- creating a 1GB hash table --
        will recognize only aligned duplicate blocks of 16KB.
      '';
    };
    options.verbosity = lib.mkOption {
      type = lib.types.enum (lib.attrNames logLevels ++ lib.attrValues logLevels);
      apply = v: if lib.isString v then logLevels.${v} else v;
      default = "info";
      description = "Log verbosity (syslog keyword/level).";
    };
    options.workDir = lib.mkOption {
      type = str;
      default = ".beeshome";
      description = ''
        Name (relative to the root of the filesystem) of the subvolume where
        the hash table will be stored.
      '';
    };
    options.extraOptions = lib.mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Extra command-line options passed to the daemon. See upstream bees documentation.
      '';
      example = lib.literalExpression ''
        [ "--thread-count" "4" ]
      '';
    };
  };

in
{

  options.services.beesd = {
    filesystems = lib.mkOption {
      type = with lib.types; attrsOf (submodule fsOptions);
      description = "BTRFS filesystems to run block-level deduplication on.";
      default = { };
      example = lib.literalExpression ''
        {
          root = {
            spec = "LABEL=root";
            hashTableSizeMB = 2048;
            verbosity = "crit";
            extraOptions = [ "--loadavg-target" "5.0" ];
          };
        }
      '';
    };
  };
  config = {
    systemd.services = lib.mapAttrs' (
      name: fs:
      lib.nameValuePair "beesd@${name}" {
        description = "Block-level BTRFS deduplication for %i";
        after = [ "sysinit.target" ];

        serviceConfig =
          let
            configOpts = [
              fs.spec
              "verbosity=${toString fs.verbosity}"
              "idxSizeMB=${toString fs.hashTableSizeMB}"
              "workDir=${fs.workDir}"
            ];
            configOptsStr = lib.escapeShellArgs configOpts;
          in
          {
            # Values from https://github.com/Zygo/bees/blob/v0.6.5/scripts/beesd@.service.in
            ExecStart = "${pkgs.bees}/bin/bees-service-wrapper run ${configOptsStr} -- --no-timestamps ${lib.escapeShellArgs fs.extraOptions}";
            ExecStopPost = "${pkgs.bees}/bin/bees-service-wrapper cleanup ${configOptsStr}";
            CPUAccounting = true;
            CPUSchedulingPolicy = "batch";
            CPUWeight = 12;
            IOSchedulingClass = "idle";
            IOSchedulingPriority = 7;
            IOWeight = 10;
            KillMode = "control-group";
            KillSignal = "SIGTERM";
            MemoryAccounting = true;
            Nice = 19;
            Restart = "on-abnormal";
            StartupCPUWeight = 25;
            StartupIOWeight = 25;
            SyslogIdentifier = "beesd"; # would otherwise be "bees-service-wrapper"
          };
        unitConfig.RequiresMountsFor = lib.mkIf (lib.hasPrefix "/" fs.spec) fs.spec;
        wantedBy = [ "multi-user.target" ];
      }
    ) cfg.filesystems;
  };
}
