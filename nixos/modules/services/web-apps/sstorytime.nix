{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    mkDefault
    mkMerge
    types
    ;

  cfg = config.services.sstorytime;
  dbName = "sstoryline";
  configPath = "/etc/sstorytime";
  stateDir = "/var/lib/sstorytime";

  defaultDatabaseUri = "postgresql://${dbName}@/${dbName}?host=/run/postgresql";

  commonServiceConfig = {
    User = dbName;
    Group = dbName;
    StateDirectory = "sstorytime";
    WorkingDirectory = "%S/sstorytime";
    EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
  };

  # linkding-manage / lasuite-*-manage: same user/state/env as the long-running unit.
  systemdRunArgs = lib.escapeShellArgs (
    [
      "--quiet"
      "--collect"
      "--pipe"
      "--wait"
      "--service-type=exec"
      "--uid=${commonServiceConfig.User}"
      "--gid=${commonServiceConfig.Group}"
      "--working-directory=${stateDir}"
      "--property=StateDirectory=${commonServiceConfig.StateDirectory}"
    ]
    ++ lib.optional (cfg.environmentFile != null) "--property=EnvironmentFile=${cfg.environmentFile}"
    ++ lib.mapAttrsToList (name: value: "--setenv=${name}=${value}") (
      cfg.settings
      // {
        PATH = lib.makeBinPath [ cfg.package ];
      }
    )
    ++ [ "--" ]
  );

  sstorytime-run = pkgs.writeShellApplication {
    name = "sstorytime-run";
    text = ''
      exec ${lib.getExe' config.systemd.package "systemd-run"} \
        ${systemdRunArgs} \
        "$@"
    '';
  };
in
{
  meta.maintainers = lib.teams.ngi.members;

  options.services.sstorytime = {
    enable = mkEnableOption "SSTorytime, a unified graph process for mapping knowledge";

    package = mkPackageOption pkgs "sstorytime" { };

    openFirewall = mkEnableOption "opening the SSTorytime ports in the firewall";

    httpPort = mkOption {
      type = types.port;
      default = 8080;
      description = "HTTP listen port (redirects to HTTPS).";
    };

    httpsPort = mkOption {
      type = types.port;
      default = 8443;
      description = "HTTPS listen port for the web UI and API.";
    };

    configDir = mkOption {
      type = types.path;
      default = "${cfg.package}/share/SSTconfig";
      defaultText = lib.literalExpression ''"''${config.services.sstorytime.package}/share/SSTconfig"'';
      description = ''
        Directory that contains configuration files to be installed under
        {file}`${configPath}`.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf (types.nullOr types.str);
        options = {
          POSTGRESQL_URI = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "postgresql://sstoryline@/sstoryline?host=/run/postgresql";
            description = ''
              PostgreSQL connection URI. When
              {option}`database.createLocally` is true, defaults to a peer-auth
              socket URI. For remote databases prefer
              {option}`environmentFile` if the URI contains secrets.
            '';
          };

          SST_CONFIG_PATH = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = configPath;
            description = ''
              Directory of SSTconfig ontology files (arrows, closures, …).
              Defaults to {file}`${configPath}` when the service is enabled.
            '';
          };
        };
      };
      default = { };
      apply = lib.filterAttrs (_: v: v != null);
      example = {
        POSTGRESQL_URI = "postgresql://sstoryline@/sstoryline?host=/run/postgresql";
      };
      description = ''
        Environment for the service and {command}`sstorytime-run`.
        Null values are omitted. Extra freeform keys are passed through as
        additional environment variables.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/sstorytime.env";
      description = ''
        Optional EnvironmentFile (e.g. secrets for `POSTGRESQL_URI` via sops).
        Used by the service and by {command}`sstorytime-run`.
      '';
    };

    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Local PostgreSQL role/database `sstoryline` and default
          {option}`settings.POSTGRESQL_URI` using the Unix socket at
          {file}`/run/postgresql` (peer auth as user `sstoryline`).
        '';
      };
    };

    finalPackage = mkOption {
      type = types.package;
      visible = false;
      readOnly = true;
      default = sstorytime-run;
      defaultText = lib.literalExpression "sstorytime-run (systemd-run wrapper)";
      description = ''
        Runs tools in a transient unit with the same user, state directory,
        and environment as {option}`systemd.services.sstorytime`.
        Example: {command}`sstorytime-run N4L -wipe -u notes.n4l`.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.database.createLocally || cfg.settings ? POSTGRESQL_URI || cfg.environmentFile != null;
        message = ''
          services.sstorytime: when database.createLocally is false, set
          settings.POSTGRESQL_URI or environmentFile (e.g. sops) so the service
          can reach PostgreSQL.
        '';
      }
    ];

    # `/*` makes etc a directory of links so nested entries can extend it.
    environment.etc.sstorytime.source = "${cfg.configDir}/*";

    environment.systemPackages = [
      cfg.package
      cfg.finalPackage
    ];

    users.users.${dbName} = {
      isSystemUser = true;
      group = dbName;
      description = "SSTorytime service and database user";
    };
    users.groups.${dbName} = { };

    services.sstorytime.settings = mkMerge [
      {
        SST_CONFIG_PATH = mkDefault configPath;
      }
      (mkIf cfg.database.createLocally {
        POSTGRESQL_URI = mkDefault defaultDatabaseUri;
      })
    ];

    systemd.services.sstorytime = {
      description = "SSTorytime Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ lib.optionals cfg.database.createLocally [ "postgresql.target" ];
      path = [ pkgs.openssl ];
      environment = cfg.settings;
      unitConfig = {
        StartLimitBurst = 5;
        StartLimitIntervalSec = 100;
      };
      preStart = ''
        mkdir -p cacheroot
        if [ ! -f cert.pem ] || [ ! -f key.pem ]; then
          openssl req -x509 -newkey rsa:4096 \
            -keyout key.pem -out cert.pem \
            -days 365 -nodes \
            -subj "/CN=localhost"
        fi
      '';
      serviceConfig = commonServiceConfig // {
        Restart = "on-failure";
        RestartSec = 5;
        ExecStart = lib.escapeShellArgs [
          (lib.getExe' cfg.package "http_server")
          "-http"
          ":${toString cfg.httpPort}"
          "-https"
          ":${toString cfg.httpsPort}"
          "-cert"
          "cert.pem"
          "-key"
          "key.pem"
        ];

        # MemoryDenyWriteExecute breaks Go.
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
      };
    };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [
      cfg.httpPort
      cfg.httpsPort
    ];

    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;
      ensureUsers = [
        {
          name = dbName;
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ dbName ];
    };
  };
}
