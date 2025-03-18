{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.antennas;
in

{
  options = {
    services.antennas = {
      enable = mkEnableOption "Antennas";

      tvheadendUrl = mkOption {
        type        = types.str;
        default     = "http://localhost:9981";
        description = "URL of Tvheadend.";
      };

      antennasUrl = mkOption {
        type        = types.str;
        default     = "http://127.0.0.1:5004";
        description = "URL of Antennas.";
      };

      tunerCount = mkOption {
        type        = types.int;
        default     = 6;
        description = "Numbers of tuners in tvheadend.";
      };

      deviceUUID = mkOption {
        type        = types.str;
        default     = "2f70c0d7-90a3-4429-8275-cbeeee9cd605";
        description = "Device tuner UUID. Change this if you are running multiple instances.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.antennas = {
      description = "Antennas HDHomeRun emulator for Tvheadend.";
      wantedBy    = [ "multi-user.target" ];

      # Config
      environment = {
        TVHEADEND_URL = cfg.tvheadendUrl;
        ANTENNAS_URL = cfg.antennasUrl;
        TUNER_COUNT = toString cfg.tunerCount;
        DEVICE_UUID = cfg.deviceUUID;
      };

      serviceConfig = {
        ExecStart = "${pkgs.antennas}/bin/antennas";

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DynamicUser = true;
        LockPersonality = true;
        ProcSubset = "pid";
        PrivateDevices = true;
        PrivateUsers = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictRealtime = true;
      };
    };
  };
}
