{
  config,
  pkgs,
  lib,
  ...
}:
let
  defaultSettings = {
    db = "/var/lib/strfry";

    dbParams = {
      maxreaders = 256;
      mapsize = 10995116277760;
      noReadAhead = false;
    };

    events = {
      maxEventSize = 65536;
      rejectEventsNewerThanSeconds = 900;
      rejectEventsOlderThanSeconds = 94608000;
      rejectEphemeralEventsOlderThanSeconds = 60;
      ephemeralEventsLifetimeSeconds = 300;
      maxNumTags = 2000;
      maxTagValSize = 1024;
    };

    relay = {
      bind = "127.0.0.1";
      port = 7777;
      nofiles = 1000000;
      realIpHeader = "";

      info = {
        name = "strfry default";
        description = "This is a strfry instance.";
        pubkey = "";
        contact = "";
        icon = "";
        nips = "";
      };

      maxWebsocketPayloadSize = 131072;
      maxReqFilterSize = 200;
      autoPingSeconds = 55;
      enableTcpKeepalive = false;
      queryTimesliceBudgetMicroseconds = 10000;
      maxFilterLimit = 500;
      maxSubsPerConnection = 20;

      writePolicy = {
        plugin = "";
      };

      compression = {
        enabled = true;
        slidingWindow = true;
      };

      logging = {
        dumpInAll = false;
        dumpInEvents = false;
        dumpInReqs = false;
        dbScanPerf = false;
        invalidEvents = true;
      };

      numThreads = {
        ingester = 3;
        reqWorker = 3;
        reqMonitor = 3;
        negentropy = 2;
      };

      negentropy = {
        enabled = true;
        maxSyncEvents = 1000000;
      };
    };
  };

  cfg = config.services.strfry;
  settingsFormat = pkgs.formats.json { };
  configFile = settingsFormat.generate "config.json" cfg.settings;
in
{
  options.services.strfry = {
    enable = lib.mkEnableOption "strfry";

    package = lib.mkPackageOption pkgs "strfry" { };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = defaultSettings;
      apply = lib.recursiveUpdate defaultSettings;
      description = "Configuration options to set for the Strfry service. See <https://github.com/hoytech/strfry> for documentation.";
      example = lib.literalExpression ''
        dbParams = {
          maxreaders = 256;
          mapsize = 10995116277760;
          noReadAhead = false;
        };
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    users.users.strfry = {
      description = "Strfry daemon user";
      group = "strfry";
      isSystemUser = true;
    };

    users.groups.strfry = { };

    systemd.services.strfry = {
      description = "strfry";
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --config=${configFile} relay";
        User = "strfry";
        Group = "strfry";
        Restart = "on-failure";

        StateDirectory = "strfry";
        WorkingDirectory = cfg.settings.db;
        ReadWritePaths = [ cfg.settings.db ];

        LimitNOFILE = cfg.settings.relay.nofiles;

        PrivateTmp = true;
        PrivateUsers = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        ProtectHostname = true;
        CapabilityBoundingSet = "";
        SystemCallFilter = [
          "@system-service"
        ];
        SystemCallArchitectures = "native";
      };
    };
  };

  meta = {
    doc = ./strfry.md;
    maintainers = with lib.maintainers; [
      felixzieger
    ];
  };
}
