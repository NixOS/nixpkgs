{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.stalwart-mail;
  configFormat = pkgs.formats.toml { };
  configFile = configFormat.generate "stalwart-mail.toml" cfg.settings;
  useLegacyStorage = lib.versionOlder config.system.stateVersion "24.11";

  parsePorts =
    listeners:
    let
      parseAddresses = listeners: lib.flatten (lib.mapAttrsToList (name: value: value.bind) listeners);
      splitAddress = addr: lib.splitString ":" addr;
      extractPort = addr: lib.toInt (builtins.foldl' (a: b: b) "" (splitAddress addr));
    in
    builtins.map (address: extractPort address) (parseAddresses listeners);

in
{
  options.services.stalwart-mail = {
    enable = lib.mkEnableOption "the Stalwart all-in-one email server";

    package = lib.mkPackageOption pkgs "stalwart-mail" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open TCP firewall ports, which are specified in
        {option}`services.stalwart-mail.settings.server.listener` on all interfaces.
      '';
    };

    settings = lib.mkOption {
      inherit (configFormat) type;
      default = { };
      description = ''
        Configuration options for the Stalwart email server.
        See <https://stalw.art/docs/category/configuration> for available options.

        By default, the module is configured to store everything locally.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/stalwart-mail";
      description = ''
        Data directory for stalwart
      '';
    };

    credentials = lib.mkOption {
      description = ''
        Credentials envs used to configure Stalwart-Mail secrets.
        These secrets can be accessed in configuration values with
        the macros such as
        `%{file:/run/credentials/stalwart-mail.service/VAR_NAME}%`.
      '';
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        user_admin_password = "/run/keys/stalwart_admin_password";
      };
    };

  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          !(
            (lib.hasAttrByPath [ "settings" "queue" ] cfg)
            && (builtins.any (lib.hasAttrByPath [
              "value"
              "next-hop"
            ]) (lib.attrsToList cfg.settings.queue))
          );
        message = ''
          Stalwart deprecated `next-hop` in favor of "virtual queues" `queue.strategy.route` \
          with v0.13.0 see [Outbound Strategy](https://stalw.art/docs/mta/outbound/strategy/#configuration) \
          and [release announcement](https://github.com/stalwartlabs/stalwart/blob/main/UPGRADING.md#upgrading-from-v012x-and-v011x-to-v013x).
        '';
      }
    ];

    # Default config: all local
    services.stalwart-mail.settings = {
      tracer.stdout = {
        type = lib.mkDefault "stdout";
        level = lib.mkDefault "info";
        ansi = lib.mkDefault false; # no colour markers to journald
        enable = lib.mkDefault true;
      };
      store =
        if useLegacyStorage then
          {
            # structured data in SQLite, blobs on filesystem
            db.type = lib.mkDefault "sqlite";
            db.path = lib.mkDefault "${cfg.dataDir}/data/index.sqlite3";
            fs.type = lib.mkDefault "fs";
            fs.path = lib.mkDefault "${cfg.dataDir}/data/blobs";
          }
        else
          {
            # everything in RocksDB
            db.type = lib.mkDefault "rocksdb";
            db.path = lib.mkDefault "${cfg.dataDir}/db";
            db.compression = lib.mkDefault "lz4";
          };
      storage.data = lib.mkDefault "db";
      storage.fts = lib.mkDefault "db";
      storage.lookup = lib.mkDefault "db";
      storage.blob = lib.mkDefault (if useLegacyStorage then "fs" else "db");
      directory.internal.type = lib.mkDefault "internal";
      directory.internal.store = lib.mkDefault "db";
      storage.directory = lib.mkDefault "internal";
      resolver.type = lib.mkDefault "system";
      resolver.public-suffix = lib.mkDefault [
        "file://${pkgs.publicsuffix-list}/share/publicsuffix/public_suffix_list.dat"
      ];
      spam-filter.resource = lib.mkDefault "file://${cfg.package.spam-filter}/spam-filter.toml";
      webadmin =
        let
          hasHttpListener = builtins.any (listener: listener.protocol == "http") (
            lib.attrValues (cfg.settings.server.listener or { })
          );
        in
        {
          path = "/var/cache/stalwart-mail";
          resource = lib.mkIf hasHttpListener (lib.mkDefault "file://${cfg.package.webadmin}/webadmin.zip");
        };
    };

    # This service stores a potentially large amount of data.
    # Running it as a dynamic user would force chown to be run everytime the
    # service is restarted on a potentially large number of files.
    # That would cause unnecessary and unwanted delays.
    users = {
      groups.stalwart-mail = { };
      users.stalwart-mail = {
        isSystemUser = true;
        group = "stalwart-mail";
      };
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - stalwart-mail stalwart-mail - -"
    ];

    systemd = {
      services.stalwart-mail = {
        description = "Stalwart Mail Server";
        wantedBy = [ "multi-user.target" ];
        after = [
          "local-fs.target"
          "network.target"
        ];

        preStart =
          if useLegacyStorage then
            ''
              mkdir -p ${cfg.dataDir}/data/blobs
            ''
          else
            ''
              mkdir -p ${cfg.dataDir}/db
            '';

        serviceConfig = {
          # Upstream service config
          Type = "simple";
          LimitNOFILE = 65536;
          KillMode = "process";
          KillSignal = "SIGINT";
          Restart = "on-failure";
          RestartSec = 5;
          SyslogIdentifier = "stalwart-mail";

          ExecStart = [
            ""
            "${lib.getExe cfg.package} --config=${configFile}"
          ];
          LoadCredential = lib.mapAttrsToList (key: value: "${key}:${value}") cfg.credentials;

          ReadWritePaths = [
            cfg.dataDir
          ];
          CacheDirectory = "stalwart-mail";
          StateDirectory = "stalwart-mail";

          # Upstream uses "stalwart" as the username since 0.12.0
          User = "stalwart-mail";
          Group = "stalwart-mail";

          # Bind standard privileged ports
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];

          # Hardening
          DeviceAllow = [ "" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          PrivateDevices = true;
          PrivateUsers = false; # incompatible with CAP_NET_BIND_SERVICE
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
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
          UMask = "0077";
        };
        unitConfig.ConditionPathExists = [
          "${configFile}"
        ];
      };
    };

    # Make admin commands available in the shell
    environment.systemPackages = [ cfg.package ];

    networking.firewall =
      lib.mkIf (cfg.openFirewall && (builtins.hasAttr "listener" cfg.settings.server))
        {
          allowedTCPPorts = parsePorts cfg.settings.server.listener;
        };
  };

  meta = {
    maintainers = with lib.maintainers; [
      happysalada
      euxane
      onny
      norpol
    ];
  };
}
