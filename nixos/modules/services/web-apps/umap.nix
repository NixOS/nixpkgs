{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  cfg = config.services.umap;
  settingsFormat = pkgs.formats.pythonVars { };
  unixSocket = "/run/umap/umap.sock";

  secretKeyFile = "${cfg.stateDir}/secretkey";

  staticDir =
    if builtins.hasAttr "UMAP_CUSTOM_STATICS" cfg.settings then
      pkgs.runCommand "${cfg.package.pname}-custom-static"
        {
          nativeBuildInputs = [ cfg.package ];
        }
        ''
          mkdir -p $out
          UMAP_SETTINGS=${settingsFormat.generate "umap-collectstatic.conf" cfg.settings} \
          STATIC_ROOT=$out \
            ${lib.getExe cfg.package} collectstatic --no-input --clear --skip-checks --link
          find $out -type l -delete
        ''
    else
      cfg.package.static;

  configFile = pkgs.concatText "umap.conf" (
    [
      (settingsFormat.generate "umap.conf" cfg.settings)
    ]
    ++ lib.optional (cfg.extraConfig != "") (pkgs.writeText "umap-extra.conf" cfg.extraConfig)
  );

  env = {
    STATIC_ROOT = "${staticDir}";
    UMAP_SETTINGS = "${configFile}";
    DATABASE_URL = cfg.settings.DATABASE_URL;
  };

  manage = pkgs.writeShellScriptBin "umap-manage" ''
    if [[ $EUID -ne 0 ]]; then
      exec sudo -E "$0" "$@"
    fi

    set -o allexport # Export the following env vars
    ${lib.toShellVars env}
    # Source auto-generated secret key first to allow user override
    if [[ -f ${secretKeyFile} ]]; then source ${secretKeyFile}; fi
    ${lib.optionalString (cfg.environmentFile != null) "source ${cfg.environmentFile}"}
    # UID is a read-only shell variable
    eval "$(${lib.getExe' config.systemd.package "systemctl"} show -pUID,GID,MainPID umap.service | ${pkgs.coreutils}/bin/tr '[:upper:]' '[:lower:]')"
    exec ${lib.getExe' pkgs.util-linux "nsenter"} \
      -t $mainpid -m -S $uid -G $gid --wdns=${lib.escapeShellArg cfg.stateDir} \
      ${lib.getExe cfg.package} "$@"
  '';
in
{
  options.services.umap = {
    enable = lib.mkEnableOption "Umap server";
    package = lib.mkPackageOption pkgs "umap" { };
    host = lib.mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "The host name or IP address the server should listen on.";
    };
    port = lib.mkOption {
      type = types.nullOr types.port;
      default = null;
      example = 9090;
      description = "The port Umap listens on. Leave unset to use the unix socket at ${unixSocket}";
    };
    stateDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/umap";
      example = "/home/foo";
      description = "State directory of Umap.";
    };

    environmentFile = lib.mkOption {
      description = ''
        Environment file to be passed to the systemd service.
        Useful for passing secrets to the service to prevent them from being
        world-readable in the Nix store.
      '';
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/var/lib/secrets/umap";
    };

    extraConfig = lib.mkOption {
      description = ''
        Additional Python code to append to the umap configuration file.
        This is useful for reading secrets from files at runtime, keeping
        them out of the Nix store.

        To read individual settings from separate files:
        ```python
        with open("/run/secrets/oidc-secret") as _f:
            SOCIAL_AUTH_OIDC_SECRET = _f.read().strip()
        ```

        To load all settings from a single Python file:
        ```python
        exec(open("/run/secrets/umap-settings.py").read())
        ```
      '';
      type = types.lines;
      default = "";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          DATABASE_URL = lib.mkOption {
            type = types.str;
            description = "Database connection URI. Automatically set when database.createLocally is enabled.";
            example = "postgres://user:pass@localhost/umap";
          };
          REDIS_URL = lib.mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Redis connection URI for realtime features. Automatically set when redis.createLocally is enabled.";
            example = "redis://localhost:6379";
          };
          UMAP_ALLOW_ANONYMOUS = lib.mkOption {
            type = types.bool;
            default = true;
            description = "Whether to allow anonymous map creation.";
          };
          SITE_URL = lib.mkOption {
            type = types.str;
            default = "";
            description = "The final URL of your instance, including the protocol.";
            example = "http://umap.org";
          };
        };
      };
      default = { };
      description = ''
        Extra configuration options to append or override.
        For available and default option values see
        [upstream configuration file](https://docs.umap-project.org/en/stable/config/settings/)
      '';
    };

    database.createLocally = lib.mkEnableOption "the creation of a local database instance" // {
      default = true;
    };

    redis.createLocally = lib.mkEnableOption "the creation of a local Redis instance" // {
      default = true;
    };

    nginx.enable = lib.mkEnableOption "an Nginx reverse proxy for Umap" // {
      default = true;
    };

    openFirewall = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for Umap.
        This adds `services.umap.port` to `networking.firewall.allowedTCPPorts`.
      '';
    };
  };
  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = !cfg.nginx.enable || cfg.settings.SITE_URL != "";
        message = "services.umap.settings.SITE_URL must be set when services.umap.nginx.enable is true.";
      }
    ];

    warnings =
      if builtins.hasAttr "SECRET_KEY" cfg.settings then
        [
          "services.umap.settings.SECRET_KEY is insecure. Either leave it empty and one will be generated or set it via services.umap.environmentFile"
        ]
      else
        [ ];

    environment.systemPackages = [ manage ];

    services.umap.settings = {
      DATABASE_URL = lib.mkIf cfg.database.createLocally (
        lib.mkOptionDefault "postgres:///umap?host=/run/postgresql&user=umap"
      );
      REDIS_URL = lib.mkIf cfg.redis.createLocally (lib.mkDefault "unix:///run/redis-umap/redis.sock");
      REALTIME_ENABLED = lib.mkOptionDefault cfg.redis.createLocally;
      MEDIA_ROOT = lib.mkOptionDefault "${cfg.stateDir}/uploads";
      LOGGING = lib.mkOptionDefault {
        version = 1;
        formatters.precise.format = "[%(levelname)s@%(name)s] %(message)s";
        disable_existing_loggers = true;
        handlers.console = {
          class = "logging.StreamHandler";
          formatter = "precise";
        };
        root = {
          level = "WARNING";
          handlers = [ "console" ];
        };
        loggers = {
          umap = {
            level = "INFO";
            handlers = [ "console" ];
            propagate = false;
          };
          django = {
            level = "INFO";
            handlers = [ "console" ];
            propagate = false;
          };
        };
      };
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      extensions = p: [ p.postgis ];
      ensureDatabases = [ "umap" ];
      ensureUsers = [
        {
          name = "umap";
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services.umap-dbsetup = lib.mkIf cfg.database.createLocally {
      description = "Umap database setup";
      requires = [ "postgresql.target" ];
      after = [
        "network.target"
        "postgresql.target"
      ];
      script = ''
        ${config.services.postgresql.package}/bin/psql umap -c "CREATE EXTENSION IF NOT EXISTS postgis"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = config.services.postgresql.superUser;
      };
    };

    services.redis.servers.umap = lib.mkIf cfg.redis.createLocally {
      enable = true;
      user = "umap";
      unixSocket = "/run/redis-umap/redis.sock";
      unixSocketPerm = 660;
    };

    systemd.services.umap = {
      description = "Umap server";
      wantedBy = [ "multi-user.target" ];
      requires =
        lib.optional cfg.database.createLocally "umap-dbsetup.service"
        ++ lib.optional cfg.redis.createLocally "redis-umap.service";
      after = [
        "network.target"
      ]
      ++ lib.optionals cfg.database.createLocally [
        "postgresql.target"
        "umap-dbsetup.service"
      ]
      ++ lib.optional cfg.redis.createLocally "redis-umap.service";
      path = [ cfg.package ];
      environment = env;

      preStart = ''
        umap wait_for_database
        umap migrate --no-input
      ''
      # The secret key can either be set via settings, environmentFile or secretKeyFile.
      # The secretKeyFile is generated if no key is found, but can later still be overridden by the user.
      + lib.optionalString (!builtins.hasAttr "SECRET_KEY" cfg.settings) ''
        if [ -z "$SECRET_KEY" ]; then
          umap shell -c "from django.core.management.utils import get_random_secret_key; import shlex; open('${secretKeyFile}', 'x').write('SECRET_KEY=' + shlex.quote(get_random_secret_key()))"
        fi
      '';

      script =
        let
          networking =
            if cfg.port != null then
              "--host ${cfg.host} --port ${toString cfg.port}"
            else
              # See: https://github.com/Kludex/uvicorn/pull/796/changes
              # Weirdly the exlicit mention was removed in a restructure: https://github.com/Kludex/uvicorn/commit/84dd2c4#diff-7f6254f34e124b6ff67f63aacb73b5252aa8e2b8afe712f48cdd3b32a24f908cL283
              # We could also set CSRF_TRUSTED_ORIGINS. I am not sure which is better...
              "--forwarded-allow-ips '*' --uds ${unixSocket}";
        in
        ''
          ${cfg.package}/bin/umap-serve --proxy-headers ${networking} --no-access-log
        '';

      serviceConfig = {
        EnvironmentFile = [
          # Load auto-generated secret key first to allow user override
          "-${secretKeyFile}"
        ]
        ++ lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        WorkingDirectory = cfg.stateDir;
        StateDirectory = "umap";
        RuntimeDirectory = "umap";
        RuntimeDirectoryMode = "0755";
        User = "umap";
        Group = "umap";
        # Hardening
        PrivateTmp = true;
        NoNewPrivileges = true;
        RestrictSUIDSGID = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        RemoveIPC = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        LockPersonality = true;
        ProtectKernelTunables = true;
        ProtectHostname = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        ProtectProc = "invisible";
        MemoryDenyWriteExecute = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        UMask = "0077";
        CapabilityBoundingSet =
          if (cfg.port != null && cfg.port < 1024) then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
        AmbientCapabilities = lib.optionals (cfg.port != null && cfg.port < 1024) [
          "CAP_NET_BIND_SERVICE"
        ];
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        DevicePolicy = "closed";
        ProcSubset = "pid";
        PrivateUsers = true;
      };
    };

    systemd.services.nginx.serviceConfig.SupplementaryGroups = lib.mkIf (
      cfg.nginx.enable && cfg.port == null
    ) [ "umap" ];

    users.groups.umap = { };
    users.users.umap = {
      isSystemUser = true;
      group = "umap";
    };

    services.nginx =
      let
        urlParts = lib.splitString "://" cfg.settings.SITE_URL;
        urlProto = builtins.elemAt urlParts 0;
        urlDomain = builtins.elemAt urlParts 1;
        upstreamTarget =
          if cfg.port != null then "${cfg.host}:${toString cfg.port}" else "unix:${unixSocket}";
      in
      lib.mkIf (cfg.nginx.enable && cfg.settings.SITE_URL != "") {
        enable = lib.mkDefault true;
        upstreams.umap.servers.${upstreamTarget} = { };
        recommendedGzipSettings = lib.mkDefault true;
        recommendedOptimisation = lib.mkDefault true;
        recommendedProxySettings = lib.mkDefault true;
        recommendedTlsSettings = lib.mkDefault true;
        virtualHosts."${urlDomain}" = {
          forceSSL = urlProto == "https";
          locations = {
            "/" = {
              proxyPass = "http://umap";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_buffering off;
              '';
            };
            "/static/" = {
              alias = "${staticDir}/";
              extraConfig = ''
                autoindex off;
                access_log off;
                log_not_found off;
                more_set_headers Cache-Control "public";
                expires 365d;
              '';
            };
            "/uploads/" = {
              alias = "${cfg.stateDir}/uploads/";
              extraConfig = ''
                autoindex off;
                access_log off;
                more_set_headers Cache-Control "public";
                expires 365d;
              '';
            };
            "/uploads/datalayer/" = {
              return = 404;
            };
          };
        };
      };

    networking.firewall = lib.mkIf (cfg.openFirewall && cfg.port != null) {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta = {
    doc = ./umap.md;
    maintainers =
      with lib.maintainers;
      [
        LorenzBischof
        jcollie
      ]
      ++ lib.teams.geospatial.members
      ++ lib.teams.ngi.members;
  };
}
