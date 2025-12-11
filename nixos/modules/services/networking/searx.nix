{
  options,
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  runDir = "/run/searx";

  cfg = config.services.searx;

  settingsFile = pkgs.writeText "settings.yml" (
    builtins.toJSON (builtins.removeAttrs cfg.settings [ "redis" ])
  );

  faviconsSettingsFile = (pkgs.formats.toml { }).generate "favicons.toml" cfg.faviconsSettings;
  limiterSettingsFile = (pkgs.formats.toml { }).generate "limiter.toml" cfg.limiterSettings;

  generateConfig = ''
    cd ${runDir}

    # write NixOS settings as JSON
    (
      umask 077
      ${pkgs.envsubst}/bin/envsubst < ${settingsFile} > settings.yml
    )
  '';

  settingType =
    with types;
    (oneOf [
      bool
      int
      float
      str
      (listOf settingType)
      (attrsOf settingType)
    ])
    // {
      description = "JSON value";
    };
in
{
  options = {
    services.searx = {
      enable = mkOption {
        type = types.bool;
        default = false;
        relatedPackages = [ "searx" ];
        description = "Whether to enable Searx, the meta search engine.";
      };

      domain = mkOption {
        type = types.str;
        description = ''
          The domain under which searxng will be served.
          Right now this is only used with the configureNginx option.
        '';
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Environment file (see {manpage}`systemd.exec(5)` "EnvironmentFile=" section for the syntax) to define variables for Searx.
          This option can be used to safely include secret keys into the Searx configuration.
        '';
      };

      redisCreateLocally = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Configure a local Redis server for SearXNG.
          This is required if you want to enable the rate limiter and bot protection of SearXNG.
        '';
      };

      settings = mkOption {
        type = types.submodule (
          { config, ... }:
          {
            options = {
              valkey = lib.mkOption {
                internal = true;
                default = { };
              };
            };
            config.valkey = lib.mkIf (config ? redis) (
              lib.warn "Obsolete option `services.searx.settings.redis' is used. It was renamed to `services.searx.settings.valkey'" config.redis
            );

            freeformType = settingType;
          }
        );
        default = { };
        example = literalExpression ''
          {
            server.port = 8080;
            server.bind_address = "0.0.0.0";
            server.secret_key = "$SEARX_SECRET_KEY";

            engines = [ {
              name = "wolframalpha";
              shortcut = "wa";
              api_key = "$WOLFRAM_API_KEY";
              engine = "wolframalpha_api";
            } ];
          }
        '';
        description = ''
          Searx settings.
          These will be merged with (taking precedence over) the default configuration.
          It's also possible to refer to environment variables (defined in [](#opt-services.searx.environmentFile)) using the syntax `$VARIABLE_NAME`.

          ::: {.note}
          For available settings, see the Searx [docs](https://docs.searxng.org/admin/settings/index.html).
          :::
        '';
      };

      settingsFile = mkOption {
        type = types.path;
        default = "${runDir}/settings.yml";
        description = ''
          The path of the Searx server settings.yml file.
          If no file is specified, a default file is used (default config file has debug mode enabled).

          ::: {.note}
          Setting this options overrides [](#opt-services.searx.settings).
          :::

          ::: {.warning}
          This file, along with any secret key it contains, will be copied into the world-readable Nix store.
          :::
        '';
      };

      faviconsSettings = mkOption {
        type = types.attrsOf settingType;
        default = { };
        example = literalExpression ''
          {
            favicons = {
              cfg_schema = 1;
              cache = {
                db_url = "/var/cache/searx/faviconcache.db";
                HOLD_TIME = 5184000;
                LIMIT_TOTAL_BYTES = 2147483648;
                BLOB_MAX_BYTES = 40960;
                MAINTENANCE_MODE = "auto";
                MAINTENANCE_PERIOD = 600;
              };
            };
          }
        '';
        description = ''
          Favicons settings for SearXNG.

          ::: {.note}
          For available settings, see the SearXNG
          [schema file](https://github.com/searxng/searxng/blob/master/searx/favicons/favicons.toml).
          :::
        '';
      };

      limiterSettings = mkOption {
        type = types.attrsOf settingType;
        default = { };
        example = literalExpression ''
          {
            real_ip = {
              x_for = 1;
              ipv4_prefix = 32;
              ipv6_prefix = 56;
            }
            botdetection.ip_lists.block_ip = [
              # "93.184.216.34" # example.org
            ];
          }
        '';
        description = ''
          Limiter settings for SearXNG.

          ::: {.note}
          For available settings, see the SearXNG [schema file](https://github.com/searxng/searxng/blob/master/searx/limiter.toml).
          :::
        '';
      };

      package = mkPackageOption pkgs "searxng" { };

      configureUwsgi = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run searx in uWSGI as a "vassal", instead of using its
          built-in HTTP server. This is the recommended mode for public or
          large instances, but is unnecessary for LAN or local-only use.

          ::: {.warning}
          The built-in HTTP server logs all queries by default.
          :::
        '';
      };

      configureNginx = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to configure nginx as an frontend to uwsgi.
        '';
      };

      uwsgiConfig = mkOption {
        inherit (options.services.uwsgi.instance) type;
        default = {
          http = ":8080";
        };
        example = literalExpression ''
          {
            disable-logging = true;
            http = ":8080";                   # serve via HTTP...
            socket = "/run/searx/searx.sock"; # ...or UNIX socket
            chmod-socket = "660";             # allow the searx group to read/write to the socket
          }
        '';
        description = ''
          Additional configuration of the uWSGI vassal running searx. It
          should notably specify on which interfaces and ports the vassal
          should listen.
        '';
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "searx" "configFile" ] [ "services" "searx" "settingsFile" ])
    (mkRenamedOptionModule [ "services" "searx" "runInUwsgi" ] [ "services" "searx" "configureUwsgi" ])
  ];

  config = mkIf cfg.enable {
    environment = {
      etc = {
        "searxng/favicons.toml" = lib.mkIf (cfg.faviconsSettings != { }) {
          source = faviconsSettingsFile;
        };
        "searxng/limiter.toml" = lib.mkIf (cfg.limiterSettings != { }) {
          source = limiterSettingsFile;
        };
      };
      systemPackages = [ cfg.package ];
    };

    services = {
      nginx = lib.mkIf cfg.configureNginx {
        enable = true;
        virtualHosts."${cfg.domain}".locations = {
          "/" = {
            recommendedProxySettings = true;
            recommendedUwsgiSettings = true;
            uwsgiPass = "unix:${config.services.uwsgi.instance.vassals.searx.socket}";
            extraConfig = # nginx
              ''
                uwsgi_param  HTTP_HOST             $host;
                uwsgi_param  HTTP_CONNECTION       $http_connection;
                uwsgi_param  HTTP_X_SCHEME         $scheme;
                uwsgi_param  HTTP_X_SCRIPT_NAME    ""; # NOTE: When we ever make the path configurable, this must be set to anything not "/"!
                uwsgi_param  HTTP_X_REAL_IP        $remote_addr;
                uwsgi_param  HTTP_X_FORWARDED_FOR  $proxy_add_x_forwarded_for;
              '';
          };
          "/static/".alias = lib.mkDefault "${cfg.package}/share/static/";
        };
      };

      redis.servers.searx = lib.mkIf cfg.redisCreateLocally {
        enable = true;
        user = "searx";
        port = 0;
      };

      searx = {
        configureUwsgi = lib.mkIf cfg.configureNginx true;
        settings = {
          # merge NixOS settings with defaults settings.yml
          use_default_settings = mkDefault true;
          server.base_url = lib.mkIf cfg.configureNginx "http${
            lib.optionalString (lib.any lib.id (
              with config.services.nginx.virtualHosts."${cfg.domain}";
              [
                onlySSL
                addSSL
                forceSSL
              ]
            )) "s"
          }://${cfg.domain}/";
          valkey = lib.mkIf cfg.redisCreateLocally {
            url = "unix://${config.services.redis.servers.searx.unixSocket}";
          };
        };
      };

      uwsgi = mkIf cfg.configureUwsgi {
        enable = true;
        plugins = [ "python3" ];
        instance.type = "emperor";
        instance.vassals.searx = {
          type = "normal";
          strict = true;
          immediate-uid = "searx";
          immediate-gid = "searx";
          lazy-apps = true;
          enable-threads = true;
          module = "searx.webapp";
          env = [
            "SEARXNG_SETTINGS_PATH=${cfg.settingsFile}"
          ];
          buffer-size = 32768;
          pythonPackages = _: [ cfg.package ];
        }
        // lib.optionalAttrs cfg.configureNginx {
          socket = "/run/searx/uwsgi.sock";
          chmod-socket = "660";
        }
        // cfg.uwsgiConfig;
      };
    };

    systemd.services = {
      nginx = lib.mkIf cfg.configureNginx {
        serviceConfig.SupplementaryGroups = [ "searx" ];
      };

      searx-init = {
        description = "Initialise Searx settings";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "searx";
          RuntimeDirectory = "searx";
          RuntimeDirectoryMode = "750";
          RuntimeDirectoryPreserve = "yes";
        }
        // optionalAttrs (cfg.environmentFile != null) {
          EnvironmentFile = cfg.environmentFile;
        };
        script = generateConfig;
      };

      searx = mkIf (!cfg.configureUwsgi) {
        description = "Searx server, the meta search engine.";
        wantedBy = [ "multi-user.target" ];
        requires = [ "searx-init.service" ];
        after = [
          "searx-init.service"
          "network.target"
        ];
        serviceConfig = {
          User = "searx";
          Group = "searx";
          ExecStart = lib.getExe cfg.package;
        }
        // optionalAttrs (cfg.environmentFile != null) {
          EnvironmentFile = cfg.environmentFile;
        };
        environment = {
          SEARXNG_SETTINGS_PATH = cfg.settingsFile;
        };
      };

      uwsgi = mkIf cfg.configureUwsgi {
        requires = [ "searx-init.service" ];
        after = [ "searx-init.service" ];
        restartTriggers = [
          cfg.package
          cfg.settingsFile
        ]
        ++ lib.optional (cfg.environmentFile != null) cfg.environmentFile;
      };
    };

    users = {
      groups.searx = { };
      users.searx = {
        description = "Searx daemon user";
        group = "searx";
        isSystemUser = true;
      };
    };
  };

  meta.maintainers = with maintainers; [
    SuperSandro2000
    _999eagle
  ];
}
