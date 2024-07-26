{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.stalwart-mail;
  configFormat = pkgs.formats.toml { };
  configFile = configFormat.generate "stalwart-mail.toml" cfg.settings;
  dataDir = "/var/lib/stalwart-mail";
  useLegacyStorage = versionOlder config.system.stateVersion "24.11";

  parsePorts = listeners: let
    parseAddresses = listeners: lib.flatten(lib.mapAttrsToList (name: value: value.bind) listeners);
    splitAddress = addr: strings.splitString ":" addr;
    extractPort = addr: strings.toInt(builtins.foldl' (a: b: b) "" (splitAddress addr));
  in
    builtins.map(address: extractPort address) (parseAddresses listeners);

in {
  options.services.stalwart-mail = {
    enable = mkEnableOption "the Stalwart all-in-one email server";

    package = mkPackageOption pkgs "stalwart-mail" { };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open TCP firewall ports, which are specified in
        {option}`services.stalwart-mail.settings.listener` on all interfaces.
      '';
    };

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
      tracer.stdout = {
        type = mkDefault "stdout";
        level = mkDefault "info";
        ansi = mkDefault false;  # no colour markers to journald
        enable = mkDefault true;
      };
      store = if useLegacyStorage then {
        # structured data in SQLite, blobs on filesystem
        db.type = mkDefault "sqlite";
        db.path = mkDefault "${dataDir}/data/index.sqlite3";
        fs.type = mkDefault "fs";
        fs.path = mkDefault "${dataDir}/data/blobs";
      } else {
        # everything in RocksDB
        db.type = mkDefault "rocksdb";
        db.path = mkDefault "${dataDir}/db";
        db.compression = mkDefault "lz4";
      };
      storage.data = mkDefault "db";
      storage.fts = mkDefault "db";
      storage.lookup = mkDefault "db";
      storage.blob = mkDefault (if useLegacyStorage then "fs" else "db");
      directory.internal.type = mkDefault "internal";
      directory.internal.store = mkDefault "db";
      storage.directory = mkDefault "internal";
      resolver.type = mkDefault "system";
      resolver.public-suffix = lib.mkDefault [
        "file://${pkgs.publicsuffix-list}/share/publicsuffix/public_suffix_list.dat"
      ];
      config.resource = {
        spam-filter = lib.mkDefault "file://${cfg.package}/etc/stalwart/spamfilter.toml";
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

    systemd = {
      packages = [ cfg.package ];
      services.stalwart-mail = {
        wantedBy = [ "multi-user.target" ];
        after = [ "local-fs.target" "network.target" ];

        preStart = if useLegacyStorage then ''
          mkdir -p ${dataDir}/data/blobs
        '' else ''
          mkdir -p ${dataDir}/db
        '';

        serviceConfig = {
          ExecStart = [
            ""
            "${cfg.package}/bin/stalwart-mail --config=${configFile}"
          ];

          StandardOutput = "journal";
          StandardError = "journal";

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
        unitConfig.ConditionPathExists = [
          ""
          "${configFile}"
        ];
      };
    };

    # Make admin commands available in the shell
    environment.systemPackages = [ cfg.package ];

    networking.firewall = mkIf (cfg.openFirewall
      && (builtins.hasAttr "listener" cfg.settings.server)) {
      allowedTCPPorts = parsePorts cfg.settings.server.listener;
    };
  };

  meta = {
    maintainers = with maintainers; [ happysalada pacien onny ];
  };
}
