{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.stalwart;

  since0_16 = lib.versionAtLeast cfg.package.version "0.16";
  configFormatName = if since0_16 then "json" else "toml";
  configFormat = pkgs.formats.${configFormatName} { };
  configFile = configFormat.generate "stalwart.${configFormatName}" cfg.settings;
  useLegacyStorage = lib.versionOlder cfg.stateVersion "24.11";
  pre2605 = lib.versionOlder cfg.stateVersion "26.05";
  stalwartIdentifier = if pre2605 then "stalwart-mail" else "stalwart";
  stalwartIdentifierText = ''if lib.versionOlder config.services.stalwart.stateVersion "26.05" then "stalwart-mail" else "stalwart"'';

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

    stateVersion = lib.mkOption {
      type = lib.types.str;
      description = ''
        The version of this module (=version of NixOS) when this module was first enabled on this particular machine, used to maintain compatibility with application data created on older versions of this module.

        See {option}`system.stateVersion` for details on the NixOS-global equivalent to this option.
      '';
    };

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
      # previously this was `inherit (configFormat) type;`, however now the config format is dependent on the package version,
      # choosing toml <0.16 and json >=0.16. thankfully, the `type` of the `json` format is identical to `toml` except the base value type is nullable
      type = (pkgs.formats.json { }).type;
      default = { };
      description = ''
        Configuration options for the Stalwart server.
        See <https://stalw.art/docs/configuration> for available options.

        By default, the module is configured to store everything locally.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/${stalwartIdentifier}";
      defaultText = lib.literalExpression "/var/lib/\${${stalwartIdentifierText}}";
      description = ''
        Data directory for stalwart
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = stalwartIdentifier;
      defaultText = lib.literalExpression stalwartIdentifierText;
      description = ''
        User ownership of service
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = stalwartIdentifier;
      defaultText = lib.literalExpression stalwartIdentifierText;
      description = ''
        Group ownership of service
      '';
    };

    url = lib.mkOption {
      type = lib.types.str;
      description = ''
        The public URL of the instance.
      '';
    };

    recovery = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to run in recovery mode, serving the web UI on `services.stalwart.recovery.port`.
        '';
      };
      port = lib.mkOption {
        type = lib.types.port;
        description = ''
          The port to serve the web UI on in bootstrap/recovery mode.
        '';
      };
    };

    admin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the fallback administrator.
        '';
      };
      username = lib.mkOption {
        type = lib.types.str;
        description = ''
          The username of the fallback administrator.
        '';
        example = "admin";
      };
      passwordFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          Path to a file containing the password for the fallback administrator.
          Make sure this password is secure, as this administrator account is active even outside of bootstrap/recovery mode.
        '';
        example = "/run/secrets/stalwart-admin-password";
      };
    };

    environmentFile = lib.mkOption {
      description = ''
        Path to a file containing extra Stalwart environment variables in the systemd `EnvironmentFile` format.
        Refer to the [documentation](https://stalw.art/docs/configuration/environment-variables/) for config options.

        This can be used to pass basic config data to Stalwart without putting them in the Nix store.
      '';
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/temporary-troubleshooting/stalwart-env";
    };

    credentials = lib.mkOption {
      description = ''
        Credentials envs used to configure Stalwart secrets.
        These secrets can be accessed in configuration values with
        macros such as `%{file:/run/credentials/stalwart.service/VAR_NAME}%` on 0.15.x,
        or `filePath` in `"@type" = "File"` secrets on 0.16+.
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
        assertion = cfg.recovery.enable -> since0_16;
        message = "<option>services.stalwart.recovery.enable</option> requires <option>services.stalwart.package</option> to be at least version 0.16";
      }
      {
        assertion = cfg.admin.enable -> since0_16;
        message = "<option>services.stalwart.admin.enable</option> requires <option>services.stalwart.package</option> to be at least version 0.16";
      }
      {
        assertion = cfg.admin.enable -> !lib.isStorePath cfg.admin.passwordFile;
        message = ''
          <option>services.stalwart.admin.passwordFile</option> points to a file in the Nix store.
          You should use a quoted absolute path to prevent this.
        '';
      }
      {
        assertion =
          since0_16
          || !(
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
    services.stalwart.settings =
      if since0_16 then
        {
          "@type" = lib.mkDefault "RocksDb";
          path = lib.mkDefault "${cfg.dataDir}/db";
        }
      else
        {
          tracer =
            if pre2605 then
              {
                stdout = {
                  type = lib.mkDefault "stdout";
                  level = lib.mkDefault "info";
                  ansi = lib.mkDefault false; # no colour markers to journald
                  enable = lib.mkDefault true;
                };
              }
            else
              {
                journal = {
                  type = lib.mkDefault "journal";
                  level = lib.mkDefault "info";
                  enable = lib.mkDefault true;
                };
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
              path = "/var/cache/${stalwartIdentifier}";
              resource = lib.mkIf hasHttpListener (lib.mkDefault "file://${cfg.package.webadmin}/webadmin.zip");
            };
        };

    # This service stores a potentially large amount of data.
    # Running it as a dynamic user would force chown to be run everytime the
    # service is restarted on a potentially large number of files.
    # That would cause unnecessary and unwanted delays.
    users = {
      groups = lib.mkIf (cfg.group == stalwartIdentifier) {
        ${cfg.group} = { };
      };
      users = lib.mkIf (cfg.user == stalwartIdentifier) {
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
          SyslogIdentifier = stalwartIdentifier;

          ExecStartPre =
            if useLegacyStorage then
              ''
                ${lib.getExe' pkgs.coreutils "mkdir"} -p ${cfg.dataDir}/data/blobs
              ''
            else
              ''
                ${lib.getExe' pkgs.coreutils "mkdir"} -p ${cfg.dataDir}/db
              '';
          ExecStart =
            let
              cmd = lib.strings.join " " (
                (lib.optionals since0_16 [
                  "STALWART_RECOVERY_MODE=${toString cfg.recovery.enable}"
                  "STALWART_RECOVERY_MODE_PORT=${toString cfg.recovery.port}"
                  "STALWART_RECOVERY_ADMIN=${lib.escapeShellArg cfg.admin.username}:`cat ${lib.escapeShellArg cfg.admin.passwordFile}`"
                  "STALWART_PUBLIC_URL=${cfg.url}"
                ])
                ++ [
                  (lib.getExe cfg.package)
                  "--config=${configFile}"
                ]
              );
            in
            "${lib.getExe pkgs.bash} -c ${lib.escapeShellArg cmd}";
          EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
          LoadCredential = lib.mapAttrsToList (key: value: "${key}:${value}") cfg.credentials;

          ReadWritePaths = [
            cfg.dataDir
          ];
          CacheDirectory = stalwartIdentifier;
          StateDirectory = stalwartIdentifier;

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
            "AF_UNIX"
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
    environment.systemPackages = [ cfg.package ] ++ (lib.optional since0_16 pkgs.stalwart-cli);

    networking.firewall =
      lib.mkIf (cfg.openFirewall && (builtins.hasAttr "listener" cfg.settings.server))
        {
          allowedTCPPorts = parsePorts cfg.settings.server.listener;
        };
  };

  meta = {
    maintainers = with lib.maintainers; [
      happysalada
      onny
      norpol
      hexstella
    ];
    doc = ./stalwart.md;
  };
}
