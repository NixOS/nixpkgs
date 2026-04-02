{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.stalwart;
  configFormat = pkgs.formats.toml { };
  configFile = configFormat.generate "stalwart.toml" cfg.settings;
  useLegacyStorage = lib.versionOlder config.system.stateVersion "24.11";
  useLegacyDefault = lib.versionOlder config.system.stateVersion "26.05";
  default = if useLegacyDefault then "stalwart-mail" else "stalwart";

  parsePorts =
    listeners:
    let
      parseAddresses = listeners: lib.flatten (lib.mapAttrsToList (name: value: value.bind) listeners);
      splitAddress = addr: lib.splitString ":" addr;
      extractPort = addr: lib.toInt (builtins.foldl' (a: b: b) "" (splitAddress addr));
    in
    map (address: extractPort address) (parseAddresses listeners);

in
{
  imports = [
    # since 0.12.0 (2025-05-26) release, upstream re-branded project to 'stalwart' due to inclusion of collaboration features (CalDAV, CardDAV, and WebDAV)
    #  https://github.com/stalwartlabs/stalwart/releases/tag/v0.12.0
    (lib.mkRenamedOptionModule [ "services" "stalwart-mail" ] [ "services" "stalwart" ])
  ];
  options.services.stalwart = {
    enable = lib.mkEnableOption "the all-in-one collaboration and mail server, Stalwart";

    package = lib.mkPackageOption pkgs "stalwart" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open TCP firewall ports, which are specified in
        {option}`services.stalwart.settings.server.listener` on all interfaces.
      '';
    };

    settings = lib.mkOption {
      inherit (configFormat) type;
      default = { };
      description = ''
        Configuration options for the Stalwart server.
        See <https://stalw.art/docs/category/configuration> for available options.

        By default, the module is configured to store everything locally.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = if useLegacyDefault then "/var/lib/stalwart-mail" else "/var/lib/stalwart";
      description = ''
        Data directory for stalwart
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      inherit default;
      description = ''
        User ownership of service
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      inherit default;
      description = ''
        Group ownership of service
      '';
    };

    credentials = lib.mkOption {
      description = ''
        Credentials envs used to configure Stalwart secrets.
        These secrets can be accessed in configuration values with
        the macros such as
        `%{file:/run/credentials/stalwart.service/VAR_NAME}%`.
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
    services.stalwart.settings = {
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
          path = "/var/cache/${default}";
          resource = lib.mkIf hasHttpListener (lib.mkDefault "file://${cfg.package.webadmin}/webadmin.zip");
        };
    };

    # This service stores a potentially large amount of data.
    # Running it as a dynamic user would force chown to be run everytime the
    # service is restarted on a potentially large number of files.
    # That would cause unnecessary and unwanted delays.
    users = {
      groups = lib.mkIf (cfg.group == default) {
        ${cfg.group} = { };
      };
      users = lib.mkIf (cfg.user == default) {
        ${cfg.user} = {
          isSystemUser = true;
          inherit (cfg) group;
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - '${cfg.user}' '${cfg.group}' - -"
    ];

    systemd = {
      services.stalwart = {
        description = "Stalwart Server";
        wantedBy = [ "multi-user.target" ];
        after = [
          "local-fs.target"
          "network.target"
        ];

        serviceConfig = {
          # Upstream service config
          Type = "simple";
          LimitNOFILE = 65536;
          KillMode = "process";
          KillSignal = "SIGINT";
          Restart = "on-failure";
          RestartSec = 5;
          SyslogIdentifier = default;

          ExecStartPre =
            if useLegacyStorage then
              ''
                ${lib.getExe' pkgs.coreutils "mkdir"} -p ${cfg.dataDir}/data/blobs
              ''
            else
              ''
                ${lib.getExe' pkgs.coreutils "mkdir"} -p ${cfg.dataDir}/db
              '';
          ExecStart = [
            ""
            "${lib.getExe cfg.package} --config=${configFile}"
          ];
          LoadCredential = lib.mapAttrsToList (key: value: "${key}:${value}") cfg.credentials;

          ReadWritePaths = [
            cfg.dataDir
          ];
          CacheDirectory = default;
          StateDirectory = default;

          # Upstream uses "stalwart" as the username since 0.12.0
          User = cfg.user;
          Group = cfg.group;

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
