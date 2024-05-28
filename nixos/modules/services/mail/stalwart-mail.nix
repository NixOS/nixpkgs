{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.stalwart-mail;
  configFormat = pkgs.formats.toml { };
  configFile = configFormat.generate "stalwart-mail.toml" cfg.settings;
  dataDir = "/var/lib/stalwart-mail";

in {
  options.services.stalwart-mail = {
    enable = mkEnableOption "the Stalwart all-in-one email server";

    package = mkPackageOption pkgs "stalwart-mail" { };

    settings = mkOption {
      inherit (configFormat) type;
      default = { };
      description = ''
        Configuration options for the Stalwart email server.
        See <https://stalw.art/docs/category/configuration> for available options.

        By default, the module is configured to store everything locally.
      '';
    };
  };

  config = mkIf cfg.enable {

    # Default config: all local
    services.stalwart-mail.settings = {
      global.tracing.method = mkDefault "stdout";
      global.tracing.level = mkDefault "info";
      queue.path = mkDefault "${dataDir}/queue";
      report.path = mkDefault "${dataDir}/reports";
      store.db.type = mkDefault "sqlite";
      store.db.path = mkDefault "${dataDir}/data/index.sqlite3";
      store.blob.type = mkDefault "fs";
      store.blob.path = mkDefault "${dataDir}/data/blobs";
      storage.data = mkDefault "db";
      storage.fts = mkDefault "db";
      storage.lookup = mkDefault "db";
      storage.blob = mkDefault "blob";
      resolver.type = mkDefault "system";
      resolver.public-suffix = lib.mkDefault [
        "file://${pkgs.publicsuffix-list}/share/publicsuffix/public_suffix_list.dat"
      ];
    };

    systemd.services.stalwart-mail = {
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" "network.target" ];

      preStart = ''
        mkdir -p ${dataDir}/{queue,reports,data/blobs}
      '';

      serviceConfig = {
        ExecStart =
          "${cfg.package}/bin/stalwart-mail --config=${configFile}";

        # Base from template resources/systemd/stalwart-mail.service
        Type = "simple";
        LimitNOFILE = 65536;
        KillMode = "process";
        KillSignal = "SIGINT";
        Restart = "on-failure";
        RestartSec = 5;
        StandardOutput = "journal";
        StandardError = "journal";
        SyslogIdentifier = "stalwart-mail";

        DynamicUser = true;
        User = "stalwart-mail";
        StateDirectory = "stalwart-mail";

        # Bind standard privileged ports
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];

        # Hardening
        DeviceAllow = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = false;  # incompatible with CAP_NET_BIND_SERVICE
        ProcSubset = "pid";
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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" ];
        UMask = "0077";
      };
    };

    # Make admin commands available in the shell
    environment.systemPackages = [ cfg.package ];
  };

  meta = {
    maintainers = with maintainers; [ happysalada pacien onny ];
  };
}
