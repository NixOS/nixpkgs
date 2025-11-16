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
  cacheDir = "/var/cache/umap";

  generatedKeyFile = "${cfg.stateDir}/secretkey";
  generateKey = cfg.secretKeyFile == null;

  # The key is passed as a systemd credential, so that only root has to read a
  # supplied file. Its directory is named after the unit, which differs between
  # the service and umap-manage, hence the lookup at runtime. Upstream's
  # SECRET_KEY environment variable keeps working and takes precedence.
  secretKey = pkgs.writeText "umap-secret-key.py" ''
    import os

    if not os.environ.get("SECRET_KEY"):
        with open(os.path.join(os.environ["CREDENTIALS_DIRECTORY"], "secret-key")) as f:
            SECRET_KEY = f.read().strip()
  '';

  # Read first, so that settings and extraConfig can still override the key.
  configFile = pkgs.concatText "umap.conf" (
    [
      secretKey
      (settingsFormat.generate "umap.conf" cfg.settings)
    ]
    ++ lib.optional (cfg.extraConfig != "") (pkgs.writeText "umap-extra.conf" cfg.extraConfig)
  );

  # Only these end up in STATICFILES_DIRS (see umap/settings/__init__.py), so an
  # unrelated setting does not recollect the statics. extraConfig is excluded as
  # well: it may read secrets at runtime.
  staticConf = settingsFormat.generate "umap-static.conf" (
    lib.filterAttrs (
      name: _:
      lib.elem name [
        "STATICFILES_DIRS"
        "UMAP_CUSTOM_STATICS"
        "UMAP_PICTOGRAMS_COLLECTIONS"
      ]
    ) cfg.settings
  );

  staticRoot = pkgs.runCommand "umap-${cfg.package.version}-static" {
    UMAP_SETTINGS = staticConf;
    STATIC_ROOT = placeholder "out";
  } "${lib.getExe cfg.package} collectstatic --no-input";

  # Osmic ships only its source icons, which fill their canvas edge to edge
  # because they are meant to be drawn at exactly that size on a map tile. Umap
  # displays a pictogram in a 24px square instead, which blows the glyph up
  # until it touches the marker border, so let osmic's own export tool inset it
  # by 4px. See tools/export.md in osmic for this config.
  osmicExport = (pkgs.formats.yaml { }).generate "osmic-export.yaml" {
    format = "svg";
    # The export runs per category, so its input is whatever --input points at
    # and the icons go straight into the directory --output names.
    input = [ { name = ""; } ];
    subdirs = false;
    # Export a single size per icon: the name carries the padded canvas size,
    # and umap stores the icon URL in every marker that uses it.
    size_filter = 14;
    global_style.padding = 4;
  };

  # Umap scans one level of categories below a `pictograms` root; osmic is already split that way.
  osmicPictograms = pkgs.runCommand "umap-pictograms-osmic-${pkgs.osmic.version}" { } ''
    for category in ${pkgs.osmic}/share/osmic/icons/*; do
      icons=$out/pictograms/$(basename "$category")
      ${lib.getExe pkgs.osmic} --input "$category" --output "$icons" ${osmicExport}
      for icon in "$icons"/*.svg; do
        mv "$icon" "''${icon%-*}.svg"
      done
    done
  '';

  env = {
    HOME = cfg.stateDir;
    STATIC_ROOT = staticRoot;
    UMAP_SETTINGS = "${configFile}";
  }
  # Umap builds DATABASES before it reads the settings file, so DATABASE_URL
  # only takes effect as an environment variable.
  // lib.optionalAttrs (cfg.settings.DATABASE_URL != null) {
    DATABASE_URL = cfg.settings.DATABASE_URL;
  };

  environmentFiles = lib.optional (cfg.environmentFile != null) cfg.environmentFile;

  credentials = [ "secret-key:${lib.defaultTo generatedKeyFile cfg.secretKeyFile}" ];

  # systemd parses the environment files, so umap-manage and the service agree
  # on quoting and escaping.
  manageArgs = lib.escapeShellArgs (
    [
      "--uid=umap"
      "--gid=umap"
      "--working-directory=${cfg.stateDir}"
    ]
    ++ map (f: "--property=EnvironmentFile=${f}") environmentFiles
    ++ map (c: "--property=LoadCredential=${c}") credentials
    ++ lib.mapAttrsToList (name: value: "--setenv=${name}=${value}") env
    # systemd-run does not inherit the invoking environment, and a valueless
    # --setenv forwards the caller's value, so `createsuperuser --noinput` works.
    ++ map (name: "--setenv=${name}") [
      "DJANGO_SUPERUSER_PASSWORD"
      "DJANGO_SUPERUSER_USERNAME"
      "DJANGO_SUPERUSER_EMAIL"
    ]
    ++ [
      "--pty"
      "--pipe"
      "--wait"
      "--collect"
      "--quiet"
      "--service-type=exec"
      "--"
      (lib.getExe cfg.package)
    ]
  );

  manage = pkgs.writeShellScriptBin "umap-manage" ''
    exec ${lib.getExe' config.systemd.package "systemd-run"} ${manageArgs} "$@"
  '';

  serviceDeps =
    lib.optionals cfg.database.createLocally [
      "postgresql.target"
      "umap-dbsetup.service"
    ]
    ++ lib.optional cfg.redis.createLocally "redis-umap.service"
    ++ lib.optional generateKey "umap-secretkey.service";

  bracketIPv6 = addr: if lib.hasInfix ":" addr then "[${addr}]" else addr;

  listen =
    if cfg.port != null then
      {
        serveArgs = "--host ${cfg.host} --port ${toString cfg.port}";
        upstream = "${bracketIPv6 cfg.host}:${toString cfg.port}";
      }
    else
      {
        # See: https://github.com/Kludex/uvicorn/pull/796/changes
        # Weirdly the exlicit mention was removed in a restructure: https://github.com/Kludex/uvicorn/commit/84dd2c4#diff-7f6254f34e124b6ff67f63aacb73b5252aa8e2b8afe712f48cdd3b32a24f908cL283
        # We could also set CSRF_TRUSTED_ORIGINS. I am not sure which is better...
        serveArgs = "--forwarded-allow-ips '*' --uds ${cfg.unixSocket}";
        upstream = "unix:${cfg.unixSocket}";
      };

  privilegedPort = cfg.port != null && cfg.port < 1024;

  urlHasProtocol = lib.hasInfix "://" cfg.settings.SITE_URL;
  urlParts = lib.splitString "://" cfg.settings.SITE_URL;
  urlProto = builtins.elemAt urlParts 0;
  # Not elemAt 1: a protocol-less SITE_URL would abort the merge before the
  # assertion below can report it.
  urlDomain = lib.last urlParts;

  # When set, umap delegates datalayer serving to nginx.
  xAccel = cfg.settings.UMAP_XSENDFILE_HEADER != null;
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
      description = "The port Umap listens on. Leave unset to use the unix socket at {option}`services.umap.unixSocket`.";
    };

    unixSocket = lib.mkOption {
      type = types.path;
      readOnly = true;
      default = "/run/umap/umap.sock";
      description = ''
        The socket Umap listens on when {option}`services.umap.port` is unset.
        Read-only, because it is provided by systemd's `RuntimeDirectory=`.
      '';
    };

    stateDir = lib.mkOption {
      type = types.path;
      readOnly = true;
      default = "/var/lib/umap";
      description = ''
        The directory holding the uploaded media and the generated secret key.
        Read-only, because it is provided by systemd's `StateDirectory=`.
      '';
    };

    secretKeyFile = lib.mkOption {
      description = ''
        File holding the secret key Django signs with. It is passed as a systemd
        credential, so it only has to be readable by root.

        When unset, a key is generated in `secretkey` inside
        {option}`services.umap.stateDir`.
      '';
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/umap-secret-key";
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

        `UMAP_CUSTOM_STATICS` and `UMAP_PICTOGRAMS_COLLECTIONS` belong in
        {option}`services.umap.settings`: the statics are collected from those,
        not from this.
      '';
      type = types.lines;
      default = "";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          DATABASE_URL = lib.mkOption {
            type = types.nullOr types.str;
            default =
              if cfg.database.createLocally then "postgres:///umap?host=/run/postgresql&user=umap" else null;
            defaultText = lib.literalMD "the local PostgreSQL socket when {option}`services.umap.database.createLocally` is enabled, otherwise `null`";
            description = ''
              Database connection URI.

              A value set here is world-readable in the Nix store; use
              {option}`services.umap.environmentFile` when it carries credentials.
            '';
            example = "postgres://localhost/umap";
          };
          REDIS_URL = lib.mkOption {
            type = types.nullOr types.str;
            default = if cfg.redis.createLocally then "unix:///run/redis-umap/redis.sock" else null;
            defaultText = lib.literalMD "the local Redis socket when {option}`services.umap.redis.createLocally` is enabled, otherwise `null`";
            description = "Redis connection URI for realtime features.";
            example = "redis://localhost:6379";
          };
          UMAP_ALLOW_ANONYMOUS = lib.mkOption {
            type = types.bool;
            default = true;
            description = "Whether to allow anonymous map creation.";
          };
          UMAP_PICTOGRAMS_COLLECTIONS = lib.mkOption {
            type = types.attrsOf (types.attrsOf types.str);
            description = ''
              Marker icon collections, keyed by the name Umap lists them under.
              Each `path` holds a `pictograms` directory with one subdirectory
              per category, as described in the
              [upstream documentation](https://docs.umap-project.org/en/stable/config/icons/).

              The [Osmic](https://github.com/gmgeo/osmic) set is served
              alongside whatever is defined here; use `lib.mkForce` to serve
              only your own collections.

              Maps store the URL of every icon they use, so renaming a category
              or removing a collection breaks the markers that reference it.
            '';
            example = lib.literalExpression ''
              {
                Pinhead = {
                  path = "''${pinheadPictograms}";
                  attribution = "Wayside Mapping";
                };
              }
            '';
          };
          SITE_URL = lib.mkOption {
            type = types.str;
            default = "";
            description = "The final URL of your instance, including the protocol.";
            example = "http://umap.org";
          };
          UMAP_XSENDFILE_HEADER = lib.mkOption {
            type = types.nullOr types.str;
            default = if cfg.nginx.enable then "X-Accel-Redirect" else null;
            defaultText = lib.literalExpression ''if config.services.umap.nginx.enable then "X-Accel-Redirect" else null'';
            description = "Header used to delegate datalayer serving to the reverse proxy. Requires the matching `/internal/` nginx location, which this module sets up.";
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
      {
        assertion = !cfg.nginx.enable || cfg.settings.SITE_URL == "" || urlHasProtocol;
        message = "services.umap.settings.SITE_URL must include the protocol (e.g. \"https://umap.org\") when services.umap.nginx.enable is true.";
      }
      {
        assertion =
          !cfg.nginx.enable
          || cfg.settings.SITE_URL == ""
          || !urlHasProtocol
          || !(lib.hasInfix "/" urlDomain || lib.hasInfix ":" urlDomain);
        message = "services.umap.settings.SITE_URL must be just the protocol and host (e.g. \"https://umap.org\"); a port, path or trailing slash is not supported when services.umap.nginx.enable is true.";
      }
      {
        assertion =
          cfg.database.createLocally || cfg.settings.DATABASE_URL != null || cfg.environmentFile != null;
        message = "services.umap.settings.DATABASE_URL must be set, or provided via services.umap.environmentFile, when services.umap.database.createLocally is disabled.";
      }
    ];

    warnings =
      lib.optional (cfg.settings ? SECRET_KEY)
        "services.umap.settings.SECRET_KEY is insecure. Either leave it empty and one will be generated or set it via services.umap.secretKeyFile";

    environment.systemPackages = [ manage ];

    services.umap.settings = {
      # A plain definition, so a collection added here merges with the default.
      UMAP_PICTOGRAMS_COLLECTIONS.Osmic = {
        path = "${osmicPictograms}";
        attribution = "Osmic";
      };
      REALTIME_ENABLED = lib.mkOptionDefault cfg.redis.createLocally;
      MEDIA_ROOT = lib.mkOptionDefault "${cfg.stateDir}/uploads";
      AJAX_PROXY_CACHE_DIR = lib.mkOptionDefault cacheDir;
      # nginx (umap group) serves uploaded media, which the service UMask would otherwise create unreadable.
      FILE_UPLOAD_DIRECTORY_PERMISSIONS = lib.mkOptionDefault (settingsFormat.lib.mkRaw "0o750");
      LOGGING = lib.mkOptionDefault {
        version = 1;
        formatters.precise.format = "[%(levelname)s@%(name)s] %(message)s";
        disable_existing_loggers = false;
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

    # A separate unit, because every umap command reads the settings, which open
    # the key, and systemd resolves the credential before the service runs.
    systemd.services.umap-secretkey = lib.mkIf generateKey {
      description = "Umap secret key generation";
      script = ''
        if [ ! -s ${generatedKeyFile} ]; then
          ${lib.getExe pkgs.openssl} rand -base64 48 > ${generatedKeyFile}
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "umap";
        Group = "umap";
        StateDirectory = "umap";
        UMask = "0077";
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
      requires = serviceDeps;
      after = [ "network.target" ] ++ serviceDeps;
      path = [ cfg.package ];
      environment = env;

      preStart = "umap migrate --no-input";

      script = ''
        ${cfg.package}/bin/umap-serve --proxy-headers ${listen.serveArgs} --no-access-log
      '';

      serviceConfig = {
        EnvironmentFile = environmentFiles;
        LoadCredential = credentials;
        WorkingDirectory = cfg.stateDir;
        StateDirectory = "umap";
        CacheDirectory = "umap";
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
        CapabilityBoundingSet = if privilegedPort then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
        AmbientCapabilities = lib.optionals privilegedPort [ "CAP_NET_BIND_SERVICE" ];
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        DevicePolicy = "closed";
        ProcSubset = "pid";
        # A private user cannot have process capabilities on the host user
        # namespace, so CAP_NET_BIND_SERVICE above would have no effect.
        PrivateUsers = !privilegedPort;
      };
    };

    systemd.services.nginx.serviceConfig.SupplementaryGroups = lib.mkIf cfg.nginx.enable [ "umap" ];

    users.groups.umap = { };
    users.users.umap = {
      isSystemUser = true;
      group = "umap";
    };

    services.nginx = lib.mkIf (cfg.nginx.enable && cfg.settings.SITE_URL != "") {
      enable = lib.mkDefault true;
      upstreams.umap.servers.${listen.upstream} = { };
      recommendedGzipSettings = lib.mkDefault true;
      recommendedOptimisation = lib.mkDefault true;
      recommendedProxySettings = lib.mkDefault true;
      recommendedTlsSettings = lib.mkDefault true;
      virtualHosts."${urlDomain}" = {
        forceSSL = lib.mkDefault (urlProto == "https");
        enableACME = lib.mkDefault (
          urlProto == "https" && config.services.nginx.virtualHosts.${urlDomain}.useACMEHost == null
        );
        locations = {
          "/" = {
            proxyPass = "http://umap";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_buffering off;
            '';
          };
          "/static/" = {
            alias = "${staticRoot}/";
            extraConfig = ''
              autoindex off;
              access_log off;
              log_not_found off;
            '';
          };
          "/uploads/" = {
            alias = "${cfg.stateDir}/uploads/";
            extraConfig = ''
              autoindex off;
              access_log off;
            '';
          };
          # Datalayers are permission-checked by the app and served via /internal/.
          "/uploads/datalayer/" = {
            return = 404;
          };
        }
        // lib.optionalAttrs xAccel {
          # X-Accel-Redirect target the app uses to hand datalayer serving to nginx.
          "/internal/" = {
            alias = "${cfg.stateDir}/uploads/";
            extraConfig = ''
              internal;
              gzip_static on;
              gzip_vary on;
              add_header X-DataLayer-Version $upstream_http_x_datalayer_version;
            '';
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
