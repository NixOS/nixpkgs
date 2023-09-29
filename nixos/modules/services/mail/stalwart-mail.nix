{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.stalwart-mail;
  configFormat = pkgs.formats.toml { };
  configFile = configFormat.generate "stalwart-mail.toml" cfg.settings;
  dataDir = "/var/lib/stalwart-mail";

in {
  options.services.stalwart-mail = {
    enable = mkEnableOption (mdDoc "the Stalwart all-in-one email server");
    package = mkPackageOptionMD pkgs "stalwart-mail" { };

    settings = mkOption {
      inherit (configFormat) type;
      default = { };
      description = mdDoc ''
        Configuration options for the Stalwart email server.
        See <https://stalw.art/docs/category/configuration> for available options.
      '';
    };

    settingsFile = mkOption {
      type = types.path;
      default = configFile;
      defaultText = ''configFormat.generate "stalwart-mail.toml" config.services.stalwart-mail.settings'';
      description = mdDoc ''
        The path of the stalwart-mail server settings.toml file.
        setting this options overrides [](#opt-services.stalwart-mail.settings).
        ::: {.warning}
        This file, along with any secret key it contains, will be copied
        into the world-readable Nix store.
        :::
      '';
    };
  };

  config = mkIf cfg.enable {
    # Default config: all local
    services.stalwart-mail.settings = {
      global.tracing.method = mkDefault "stdout";
      global.tracing.level = mkDefault "info";
      #queue.path = mkDefault "${dataDir}/queue";
      #report.path = mkDefault "${dataDir}/reports";
      #store.db.path = mkDefault "${dataDir}/data/index.sqlite3";
      #store.blob.type = mkDefault "local";
      #store.blob.local.path = mkDefault "${dataDir}/data/blobs";
      #resolver.type = mkDefault "system";
    };

    systemd.services.stalwart-mail = {
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" "network.target" ];

      preStart = ''
        mkdir -p ${dataDir}/{queue,reports,data/blobs}
      '';

      serviceConfig = {
        ExecStart =
          "${cfg.package}/bin/stalwart-mail --config=${cfg.settingsFile}";

        # Base from template resources/systemd/stalwart-mail.service
        Type = "simple";
        LimitNOFILE = 65536;
        KillMode = "process";
        KillSignal = "SIGINT";
        Restart = "on-failure";
        RestartSec = 5;
        StandardOutput = "syslog";
        StandardError = "syslog";
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
    maintainers = with maintainers; [ happysalada pacien ];
  };
}
