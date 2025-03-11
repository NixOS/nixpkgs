{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.nostr-rs-relay;
  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "config.toml" (
    cfg.settings
    // {
      database = {
        data_directory = config.services.nostr-rs-relay.dataDir;
      };
      network = {
        port = config.services.nostr-rs-relay.port;
      };
    }
  );
in
{
  options.services.nostr-rs-relay = {
    enable = lib.mkEnableOption "nostr-rs-relay";

    package = lib.mkPackageOption pkgs "nostr-rs-relay" { };

    port = lib.mkOption {
      default = 12849;
      type = lib.types.port;
      description = "Listen on this port.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/nostr-rs-relay";
      description = "Directory for SQLite files.";
    };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = "See https://git.sr.ht/~gheartsfield/nostr-rs-relay/#configuration for documentation.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nostr-rs-relay = {
      description = "nostr-rs-relay";
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/nostr-rs-relay --config ${configFile}";
        DynamicUser = true;
        Restart = "on-failure";
        Type = "simple";

        ReadWritePaths = [ cfg.dataDir ];

        RuntimeDirectory = "nostr-rs-relay";
        StateDirectory = "nostr-rs-relay";

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

  meta.maintainers = with lib.maintainers; [
    felixzieger
    jb55
  ];
}
