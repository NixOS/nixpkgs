{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.snapraid;
in
{
  imports = [
    # Should have never been on the top-level.
    (mkRenamedOptionModule [ "snapraid" ] [ "services" "snapraid" ])
  ];

  options.services.snapraid = with types; {
    enable = mkEnableOption "SnapRAID";
    dataDisks = mkOption {
      default = { };
      example = {
        d1 = "/mnt/disk1/";
        d2 = "/mnt/disk2/";
        d3 = "/mnt/disk3/";
      };
      description = "SnapRAID data disks.";
      type = attrsOf str;
    };
    parityFiles = mkOption {
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
    contentFiles = mkOption {
      default = [ ];
      example = [
        "/var/snapraid.content"
        "/mnt/disk1/snapraid.content"
        "/mnt/disk2/snapraid.content"
      ];
      description = "SnapRAID content list files.";
      type = listOf str;
    };
    exclude = mkOption {
      default = [ ];
      example = [ "*.unrecoverable" "/tmp/" "/lost+found/" ];
      description = "SnapRAID exclude directives.";
      type = listOf str;
    };
    touchBeforeSync = mkOption {
      default = true;
      example = false;
      description =
        "Whether {command}`snapraid touch` should be run before {command}`snapraid sync`.";
      type = bool;
    };
    sync.interval = mkOption {
      default = "01:00";
      example = "daily";
      description = "How often to run {command}`snapraid sync`.";
      type = str;
    };
    scrub = {
      interval = mkOption {
        default = "Mon *-*-* 02:00:00";
        example = "weekly";
        description = "How often to run {command}`snapraid scrub`.";
        type = str;
      };
      plan = mkOption {
        default = 8;
        example = 5;
        description =
          "Percent of the array that should be checked by {command}`snapraid scrub`.";
        type = int;
      };
      olderThan = mkOption {
        default = 10;
        example = 20;
        description =
          "Number of days since data was last scrubbed before it can be scrubbed again.";
        type = int;
      };
    };
    extraConfig = mkOption {
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
    mkIf cfg.enable {
      assertions = [
        {
          assertion = nParity <= 6;
          message = "You can have no more than six SnapRAID parity files.";
        }
        {
          assertion = builtins.length cfg.contentFiles >= nParity + 1;
          message =
            "There must be at least one SnapRAID content file for each SnapRAID parity file plus one.";
        }
      ];

      environment = {
        systemPackages = with pkgs; [ snapraid ];

        etc."snapraid.conf" = {
          text = with cfg;
            let
              prependData = mkPrepend "data ";
              prependContent = mkPrepend "content ";
              prependExclude = mkPrepend "exclude ";
            in
            concatStringsSep "\n"
              (map prependData
                ((mapAttrsToList (name: value: name + " " + value)) dataDisks)
              ++ zipListsWith (a: b: a + b)
                ([ "parity " ] ++ map (i: toString i + "-parity ") (range 2 6))
                parityFiles ++ map prependContent contentFiles
              ++ map prependExclude exclude) + "\n" + extraConfig;
        };
      };

      systemd.services = with cfg; {
        snapraid-scrub = {
          description = "Scrub the SnapRAID array";
          startAt = scrub.interval;
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.snapraid}/bin/snapraid scrub -p ${
              toString scrub.plan
            } -o ${toString scrub.olderThan}";
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
              unique (
                attrValues dataDisks ++ contentDirs
              );
          };
          unitConfig.After = "snapraid-sync.service";
        };
        snapraid-sync = {
          description = "Synchronize the state of the SnapRAID array";
          startAt = sync.interval;
          serviceConfig = {
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
            CapabilityBoundingSet = "CAP_DAC_OVERRIDE" +
              lib.optionalString cfg.touchBeforeSync " CAP_FOWNER";

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
                splitParityFiles = map (s: splitString "," s) parityFiles;
              in
              unique (
                attrValues dataDisks ++ splitParityFiles ++ contentDirs
              );
          } // optionalAttrs touchBeforeSync {
            ExecStartPre = "${pkgs.snapraid}/bin/snapraid touch";
          };
        };
      };
    };
}
