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
  stateDir = "/var/lib/umap";
  # uMap 3.8 requires AJAX_PROXY_CACHE_DIR to be set and writable, checked at
  # startup by umap.E001. It holds only the regenerable CORS proxy cache, which
  # `umap clear_proxy_cache` prunes, so it belongs in /var/cache.
  cacheDir = "/var/cache/umap";

  # SECRET_KEY precedence:
  # extraConfig > settings > environmentFile > this generated file.
  secretKeyFile = "${stateDir}/secretkey";

  # umap.settings holds the merged settings, so this sees a key from any source.
  generateSecretKey = pkgs.writeText "umap-generate-secret-key.py" ''
    import os
    import shlex

    import umap.settings
    from django.core.management.utils import get_random_secret_key

    if not getattr(umap.settings, "SECRET_KEY", None):
        tmp = "${secretKeyFile}.tmp"
        with open(tmp, "w") as f:
            f.write("SECRET_KEY=" + shlex.quote(get_random_secret_key()))
        os.replace(tmp, "${secretKeyFile}")
  '';

  configFile = pkgs.concatText "umap.conf" (
    [
      # DATABASE_URL is only honoured as an environment variable: umap bakes it
      # into DATABASES before this file is read.
      (settingsFormat.generate "umap.conf" (removeAttrs cfg.settings [ "DATABASE_URL" ]))
    ]
    ++ lib.optional (cfg.extraConfig != "") (pkgs.writeText "umap-extra.conf" cfg.extraConfig)
  );

  env = {
    HOME = stateDir;
    STATIC_ROOT = "${stateDir}/static";
    UMAP_SETTINGS = "${configFile}";
  }
  // lib.optionalAttrs (cfg.settings.DATABASE_URL != null) {
    DATABASE_URL = cfg.settings.DATABASE_URL;
  };

  # systemd parses the environment files, so umap-manage and the service agree
  # on quoting and escaping.
  manageArgs = lib.escapeShellArgs (
    [
      "--uid=umap"
      "--gid=umap"
      "--working-directory=${stateDir}"
      # Generated key first, so environmentFile overrides it.
      "--property=EnvironmentFile=-${secretKeyFile}"
    ]
    ++ lib.optional (cfg.environmentFile != null) "--property=EnvironmentFile=${cfg.environmentFile}"
    ++ lib.mapAttrsToList (name: value: "--setenv=${name}=${value}") env
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

  bracketIPv6 = addr: if lib.hasInfix ":" addr then "[${addr}]" else addr;

  urlHasProtocol = lib.hasInfix "://" cfg.settings.SITE_URL;
  urlParts = lib.splitString "://" cfg.settings.SITE_URL;
  urlProto = builtins.elemAt urlParts 0;
  # Not elemAt 1: a protocol-less SITE_URL would abort the merge before the
  # assertion below can report it.
  urlDomain = lib.last urlParts;

  # When set, umap delegates both datalayer and CORS-proxy serving to nginx.
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
      description = "The port Umap listens on. Leave unset to use the unix socket at ${unixSocket}";
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
            description = "Header used to delegate datalayer and CORS-proxy serving to the reverse proxy. Requires the matching nginx locations, which this module sets up.";
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

    nginx.useACMEHost = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "example.com";
      description = ''
        Serve the Nginx virtual host with an existing ACME certificate
        registered under this name in [](#opt-security.acme.certs), instead of
        requesting a dedicated one for Umap.

        This lets several services share a single certificate, for example a
        wildcard certificate covering `*.example.com`, which avoids requesting a
        separate certificate per subdomain and hitting the Let's Encrypt
        [rate limit](https://letsencrypt.org/docs/rate-limits).

        *The referenced certificate must already be defined in
        [](#opt-security.acme.certs).*
      '';
    };

    nginx.resolver = lib.mkOption {
      type = types.str;
      default =
        if config.services.resolved.enable then
          "127.0.0.53"
        else
          lib.concatMapStringsSep " " bracketIPv6 config.networking.nameservers;
      defaultText = lib.literalMD "`127.0.0.53` when systemd-resolved is enabled, otherwise {option}`networking.nameservers`";
      example = "1.1.1.1";
      description = ''
        DNS resolver Nginx uses for the CORS proxy (`/proxy/`), which is required
        when `services.umap.settings.UMAP_XSENDFILE_HEADER` is set (the default).
      '';
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
        assertion = !cfg.nginx.enable || !xAccel || cfg.nginx.resolver != "";
        message = "services.umap.nginx.resolver must be set: the CORS proxy needs a DNS resolver when services.umap.settings.UMAP_XSENDFILE_HEADER is enabled.";
      }
      {
        assertion =
          cfg.database.createLocally || cfg.settings.DATABASE_URL != null || cfg.environmentFile != null;
        message = "services.umap.settings.DATABASE_URL must be set, or provided via services.umap.environmentFile, when services.umap.database.createLocally is disabled.";
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
      REALTIME_ENABLED = lib.mkOptionDefault cfg.redis.createLocally;
      MEDIA_ROOT = lib.mkOptionDefault "${stateDir}/uploads";
      AJAX_PROXY_CACHE_DIR = lib.mkOptionDefault cacheDir;
      # nginx (umap group) serves uploaded media and collected statics, which the service UMask would otherwise create unreadable.
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
        # Umap derives STATICFILES_DIRS from the settings file, so the collected
        # statics depend on the config as well as on the package.
        staticStamp="${stateDir}/.static-stamp"
        wantStamp="${cfg.package} ${configFile}"
        if [[ "$(cat "$staticStamp" 2>/dev/null)" != "$wantStamp" ]]; then
          umap collectstatic --no-input --clear
          echo "$wantStamp" > "$staticStamp"
        fi
        umap wait_for_database
        umap migrate --no-input

        # Skip the startup cost when a key is already in the environment, either
        # from environmentFile or from a previous run.
        if [ -z "$SECRET_KEY" ]; then
          umap shell < ${generateSecretKey}
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
          # Generated key first, so environmentFile overrides it.
          "-${secretKeyFile}"
        ]
        ++ lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        WorkingDirectory = stateDir;
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
        # A private user cannot have process capabilities on the host user
        # namespace, so CAP_NET_BIND_SERVICE above would have no effect.
        PrivateUsers = cfg.port == null || cfg.port >= 1024;
      };
    };

    systemd.services.nginx.serviceConfig.SupplementaryGroups = lib.mkIf cfg.nginx.enable [ "umap" ];

    users.groups.umap = { };
    users.users.umap = {
      isSystemUser = true;
      group = "umap";
    };

    services.nginx =
      let
        upstreamTarget =
          if cfg.port != null then "${bracketIPv6 cfg.host}:${toString cfg.port}" else "unix:${unixSocket}";
      in
      lib.mkIf (cfg.nginx.enable && cfg.settings.SITE_URL != "") {
        enable = lib.mkDefault true;
        upstreams.umap.servers.${upstreamTarget} = { };
        proxyCachePath.ajax_proxy = lib.mkIf xAccel {
          enable = true;
          keysZoneName = "ajax_proxy";
        };
        recommendedGzipSettings = lib.mkDefault true;
        recommendedOptimisation = lib.mkDefault true;
        recommendedProxySettings = lib.mkDefault true;
        recommendedTlsSettings = lib.mkDefault true;
        virtualHosts."${urlDomain}" = {
          forceSSL = lib.mkDefault (urlProto == "https");
          enableACME = lib.mkDefault (
            urlProto == "https" && config.services.nginx.virtualHosts.${urlDomain}.useACMEHost == null
          );
          useACMEHost = lib.mkIf (cfg.nginx.useACMEHost != null) cfg.nginx.useACMEHost;
          locations = {
            "/" = {
              proxyPass = "http://umap";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_buffering off;
              '';
            };
            "/static/" = {
              alias = "${stateDir}/static/";
              extraConfig = ''
                autoindex off;
                access_log off;
                log_not_found off;
              '';
            };
            "/uploads/" = {
              alias = "${stateDir}/uploads/";
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
              alias = "${stateDir}/uploads/";
              extraConfig = ''
                internal;
                gzip_static on;
                gzip_vary on;
                add_header X-DataLayer-Version $upstream_http_x_datalayer_version;
              '';
            };
            # CORS proxy: the app authorizes a remote URL, then nginx fetches and caches it.
            "~ ^/proxy/(.*)" = {
              extraConfig = ''
                internal;
                add_header X-Proxy-Cache $upstream_cache_status always;
                proxy_cache_background_update on;
                proxy_cache_use_stale updating;
                proxy_cache ajax_proxy;
                proxy_cache_valid 1m;
                set $target_url $1;
                if ( $target_url ~ (.+)%3A%2F%2F(.+) ){
                  set $target_url $1://$2;
                }
                if ( $target_url ~ (.+?)%3A(.*) ){
                  set $target_url $1:$2;
                }
                if ( $target_url ~ (.+?)%2F(.*) ){
                  set $target_url $1/$2;
                }
                resolver ${cfg.nginx.resolver};
                proxy_pass_request_headers off;
                proxy_set_header Content-Type $http_content_type;
                proxy_set_header Content-Encoding $http_content_encoding;
                proxy_set_header Content-Length $http_content_length;
                proxy_read_timeout 10s;
                proxy_connect_timeout 5s;
                proxy_ssl_server_name on;
                proxy_pass $target_url;
                proxy_intercept_errors on;
                error_page 301 302 307 = @handle_proxy_redirect;
              '';
            };
            # The header filtering above is not inherited here, so it is
            # repeated: without it nginx sends the client cookies to the
            # redirect target.
            "@handle_proxy_redirect" = {
              extraConfig = ''
                resolver ${cfg.nginx.resolver};
                proxy_pass_request_headers off;
                proxy_set_header Content-Type $http_content_type;
                proxy_set_header Content-Encoding $http_content_encoding;
                proxy_set_header Content-Length $http_content_length;
                set $saved_redirect_location '$upstream_http_location';
                proxy_pass $saved_redirect_location;
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
