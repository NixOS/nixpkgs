{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.snapraid;
in
{
  imports = [
    # Should have never been on the top-level.
    (lib.mkRenamedOptionModule [ "snapraid" ] [ "services" "snapraid" ])
  ];

  options.services.snapraid = with lib.types; {
    enable = lib.mkEnableOption "SnapRAID";
    dataDisks = lib.mkOption {
      default = { };
      example = {
        d1 = "/mnt/disk1/";
        d2 = "/mnt/disk2/";
        d3 = "/mnt/disk3/";
      };
      description = "SnapRAID data disks.";
      type = attrsOf str;
    };
    parityFiles = lib.mkOption {
      default = [ ];
      example = [
        "/mnt/diskp/snapraid.parity"
        "/mnt/diskq/snapraid.2-parity"
        "/mnt/diskr/snapraid.3-parity"
        "/mnt/disks/snapraid.4-parity"
        "/mnt/diskt/snapraid.5-parity"
        "/mnt/disku/snapraid.6-parity"
      ];
      description = "SnapRAID parity files.";
      type = listOf str;
    };
    contentFiles = lib.mkOption {
      default = [ ];
      example = [
        "/var/snapraid.content"
        "/mnt/disk1/snapraid.content"
        "/mnt/disk2/snapraid.content"
      ];
      description = "SnapRAID content list files.";
      type = listOf str;
    };
    exclude = lib.mkOption {
      default = [ ];
      example = [
        "*.unrecoverable"
        "/tmp/"
        "/lost+found/"
      ];
      description = "SnapRAID exclude directives.";
      type = listOf str;
    };
    touchBeforeSync = lib.mkOption {
      default = true;
      example = false;
      description = "Whether {command}`snapraid touch` should be run before {command}`snapraid sync`.";
      type = bool;
    };
    sync.interval = lib.mkOption {
      default = "01:00";
      example = "daily";
      description = "How often to run {command}`snapraid sync`.";
      type = str;
    };
    scrub = {
      interval = lib.mkOption {
        default = "Mon *-*-* 02:00:00";
        example = "weekly";
        description = "How often to run {command}`snapraid scrub`.";
        type = str;
      };
      plan = lib.mkOption {
        default = 8;
        example = 5;
        description = "Percent of the array that should be checked by {command}`snapraid scrub`.";
        type = int;
      };
      olderThan = lib.mkOption {
        default = 10;
        example = 20;
        description = "Number of days since data was last scrubbed before it can be scrubbed again.";
        type = int;
      };
    };
    extraConfig = lib.mkOption {
      default = "";
      example = ''
        nohidden
        blocksize 256
        hashsize 16
        autosave 500
        pool /pool
      '';
      description = "Extra config options for SnapRAID.";
      type = lines;
    };
  };

  config =
    let
      nParity = builtins.length cfg.parityFiles;
      mkPrepend = pre: s: pre + s;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = nParity <= 6;
          message = "You can have no more than six SnapRAID parity files.";
        }
        {
          assertion = builtins.length cfg.contentFiles >= nParity + 1;
          message = "There must be at least one SnapRAID content file for each SnapRAID parity file plus one.";
        }
      ];

      environment = {
        systemPackages = with pkgs; [ snapraid ];

        etc."snapraid.conf" = {
          text =
            with cfg;
            let
              prependData = mkPrepend "data ";
              prependContent = mkPrepend "content ";
              prependExclude = mkPrepend "exclude ";
            in
            lib.concatStringsSep "\n" (
              map prependData ((lib.mapAttrsToList (name: value: name + " " + value)) dataDisks)
              ++ lib.zipListsWith (a: b: a + b) (
                [ "parity " ] ++ map (i: toString i + "-parity ") (lib.range 2 6)
              ) parityFiles
              ++ map prependContent contentFiles
              ++ map prependExclude exclude
            )
            + "\n"
            + extraConfig;
        };
      };

      systemd.services = with cfg; {
        snapraid-scrub = {
          description = "Scrub the SnapRAID array";
          startAt = scrub.interval;
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.snapraid}/bin/snapraid scrub -p ${toString scrub.plan} -o ${toString scrub.olderThan}";
            Nice = 19;
            IOSchedulingPriority = 7;
            CPUSchedulingPolicy = "batch";

            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            RestrictAddressFamilies = "none";
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = "@system-service";
            SystemCallErrorNumber = "EPERM";
            CapabilityBoundingSet = "CAP_DAC_OVERRIDE";

            ProtectSystem = "strict";
            ProtectHome = "read-only";
            ReadWritePaths =
              # scrub requires access to directories containing content files
              # to remove them if they are stale
              let
                contentDirs = map dirOf contentFiles;
              in
              lib.unique (lib.attrValues dataDisks ++ contentDirs);
          };
          unitConfig.After = "snapraid-sync.service";
        };
        snapraid-sync = {
          description = "Synchronize the state of the SnapRAID array";
          startAt = sync.interval;
          serviceConfig =
            {
              Type = "oneshot";
              ExecStart = "${pkgs.snapraid}/bin/snapraid sync";
              Nice = 19;
              IOSchedulingPriority = 7;
              CPUSchedulingPolicy = "batch";

              LockPersonality = true;
              MemoryDenyWriteExecute = true;
              NoNewPrivileges = true;
              PrivateTmp = true;
              ProtectClock = true;
              ProtectControlGroups = true;
              ProtectHostname = true;
              ProtectKernelLogs = true;
              ProtectKernelModules = true;
              ProtectKernelTunables = true;
              RestrictAddressFamilies = "none";
              RestrictNamespaces = true;
              RestrictRealtime = true;
              RestrictSUIDSGID = true;
              SystemCallArchitectures = "native";
              SystemCallFilter = "@system-service";
              SystemCallErrorNumber = "EPERM";
              CapabilityBoundingSet = "CAP_DAC_OVERRIDE" + lib.optionalString cfg.touchBeforeSync " CAP_FOWNER";

              ProtectSystem = "strict";
              ProtectHome = "read-only";
              ReadWritePaths =
                # sync requires access to directories containing content files
                # to remove them if they are stale
                let
                  contentDirs = map dirOf contentFiles;
                  # Multiple "split" parity files can be specified in a single
                  # "parityFile", separated by a comma.
                  # https://www.snapraid.it/manual#7.1
                  splitParityFiles = map (s: lib.splitString "," s) parityFiles;
                in
                lib.unique (lib.attrValues dataDisks ++ splitParityFiles ++ contentDirs);
            }
            // lib.optionalAttrs touchBeforeSync {
              ExecStartPre = "${pkgs.snapraid}/bin/snapraid touch";
            };
        };
      };
    };
}
