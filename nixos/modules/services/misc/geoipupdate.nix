{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.geoipupdate;
  configFile = pkgs.writeText "geoipupdate.conf" ''
    AccountID ${cfg.accountID}
    LicenseKey ${cfg.licenseKey}
    EditionIDs ${concatStringsSep " " cfg.editionIDs}
    ${concatStringsSep "\n" (mapAttrsToList (k: v: "${k} ${v}") cfg.extraConfig)}
  '';
in {
  options.services.geoipupdate = with types; {
    enable = mkEnableOption "the automated GeoIP updater";

    accountID = mkOption {
      description = "Account ID of your MaxMind account (or 0 for free GeoLite DBs)";
      type = str;
      default = "0";
    };

    licenseKey = mkOption {
      description = "License key of your MaxMind account (or 000000000000 for free GeoLite DBs)";
      type = str;
      default = "000000000000";
    };

    editionIDs = mkOption {
      description = "Edition IDs to update";
      type = listOf str;
      default = [ "GeoLite2-Country" "GeoLite2-City" ];
    };

    extraConfig = mkOption {
      description = "Extra configuration to append to the configuration file";
      type = attrsOf str;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    systemd.services.geoipupdate = {
      description = "MaxMind GeoIP updater";
      after = [ "networking.target" ];
      wantedBy = [ "multi-user.target" ];
      startAt = "weekly";

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.geoipupdate}/bin/geoipupdate -d /var/lib/GeoIP -f ${configFile}";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        StateDirectory = "GeoIP";
        StateDirectoryMode = "0755";

        User = "geoipupdate";

        CapabilityBoundingSet = "";
        NoNewPrivileges = true;

        LockPersonality = true;
        RestrictRealtime = true;
        PrivateMounts = true;
        PrivateUsers = true;
        MemoryDenyWriteExecute = true;
        SystemCallFilter = "@basic-io @file-system @network-io @system-service";
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = "AF_INET AF_INET6";
      };
    };

    systemd.timers.geoipupdate.timerConfig.RandomizedDelaySec = "1h";

    users.users.geoipupdate = {
      description = "Geoipupdate service user";
      isSystemUser = true;
    };
  };

  meta.maintainers = with maintainers; [ das_j ];
}
