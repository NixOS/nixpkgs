{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.upki;
  format = pkgs.formats.toml { };
  configFile = format.generate "upki.toml" cfg.settings;
in
{
  options.services.upki = {
    enable = lib.mkEnableOption "upki certificate infrastructure cache updates";

    package = lib.mkPackageOption pkgs "upki" { };

    interval = lib.mkOption {
      type = lib.types.str;
      default = "2h";
      example = "1h";
      description = "How often to update the upki cache.";
    };

    settings = lib.mkOption {
      inherit (format) type;
      default = { };
      description = "Settings written to the upki config file.";
      example = lib.literalExpression ''
        {
          cache-dir = "/var/cache/upki";
          revocation.fetch-url = "https://upki.rustls.dev/";
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."upki/config.toml".source = configFile;

    services.upki.settings = {
      cache-dir = lib.mkDefault "/var/cache/upki";
      revocation.fetch-url = lib.mkDefault "https://upki.rustls.dev/";
    };

    users.users.upki = {
      isSystemUser = true;
      group = "upki";
    };
    users.groups.upki = { };

    systemd.tmpfiles.settings."upki" = {
      "/var/cache/upki".d = {
        mode = "0755";
        user = "upki";
        group = "upki";
      };
      "/var/cache/upki/revocation".d = {
        mode = "0755";
        user = "upki";
        group = "upki";
      };
    };

    systemd.services.upki-fetch = {
      description = "Update the upki cache";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      restartTriggers = [ config.environment.etc."upki/config.toml".source ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe cfg.package} --config-file /etc/upki/config.toml fetch";
        User = "upki";
        Group = "upki";
        ConfigurationDirectory = "upki";
        CacheDirectory = "upki/revocation";
        CacheDirectoryMode = "0755";
        UMask = "0022";

        # Hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectKernelLogs = true;
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        ProcSubset = "pid";
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @resources"
        ];
        CapabilityBoundingSet = [ "" ];
        AmbientCapabilities = [ "" ];
      };
    };

    systemd.timers.upki-fetch = {
      description = "Update the upki cache every ${cfg.interval}";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "10min";
        OnUnitActiveSec = cfg.interval;
        Persistent = true;
      };
    };
  };

  meta = {
    maintainers = [ lib.maintainers.skyesoss ];
  };
}
