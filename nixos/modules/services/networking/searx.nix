{ options, config, lib, pkgs, ... }:

let
  runDir = "/run/searx";

  cfg = config.services.searx;

  settingsFile = pkgs.writeText "settings.yml"
    (builtins.toJSON cfg.settings);

  limiterSettingsFile = (pkgs.formats.toml { }).generate "limiter.toml" cfg.limiterSettings;

  generateConfig = ''
    cd ${runDir}

    # write NixOS settings as JSON
    (
      umask 077
      cp --no-preserve=mode ${settingsFile} settings.yml
    )

    # substitute environment variables
    env -0 | while IFS='=' read -r -d ''' n v; do
      sed "s#@$n@#$v#g" -i settings.yml
    done
  '';

  settingType = (lib.types.oneOf
    [
      lib.types.bool
      lib.types.int
      lib.types.float
      lib.types.str
      (lib.types.listOf settingType)
      (lib.types.attrsOf settingType)
    ]) // { description = "JSON value"; };

in

{

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "searx" "configFile" ]
      [ "services" "searx" "settingsFile" ])
  ];

  options = {
    services.searx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        relatedPackages = [ "searx" ];
        description = "Whether to enable Searx, the meta search engine.";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Environment file (see `systemd.exec(5)`
          "EnvironmentFile=" section for the syntax) to define variables for
          Searx. This option can be used to safely include secret keys into the
          Searx configuration.
        '';
      };

      redisCreateLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Configure a local Redis server for SearXNG. This is required if you
          want to enable the rate limiter and bot protection of SearXNG.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.attrsOf settingType;
        default = { };
        example = lib.literalExpression ''
          { server.port = 8080;
            server.bind_address = "0.0.0.0";
            server.secret_key = "@SEARX_SECRET_KEY@";

            engines = lib.singleton
              { name = "wolframalpha";
                shortcut = "wa";
                api_key = "@WOLFRAM_API_KEY@";
                engine = "wolframalpha_api";
              };
          }
        '';
        description = ''
          Searx settings. These will be merged with (taking precedence over)
          the default configuration. It's also possible to refer to
          environment variables
          (defined in [](#opt-services.searx.environmentFile))
          using the syntax `@VARIABLE_NAME@`.

          ::: {.note}
          For available settings, see the Searx
          [docs](https://searx.github.io/searx/admin/settings.html).
          :::
        '';
      };

      settingsFile = lib.mkOption {
        type = lib.types.path;
        default = "${runDir}/settings.yml";
        description = ''
          The path of the Searx server settings.yml file. If no file is
          specified, a default file is used (default config file has debug mode
          enabled). Note: setting this options overrides
          [](#opt-services.searx.settings).

          ::: {.warning}
          This file, along with any secret key it contains, will be copied
          into the world-readable Nix store.
          :::
        '';
      };

      limiterSettings = lib.mkOption {
        type = lib.types.attrsOf settingType;
        default = { };
        example = lib.literalExpression ''
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
          For available settings, see the SearXNG
          [schema file](https://github.com/searxng/searxng/blob/master/searx/limiter.toml).
          :::
        '';
      };

      package = lib.mkPackageOption pkgs "searxng" { };

      runInUwsgi = lib.mkOption {
        type = lib.types.bool;
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

      uwsgiConfig = lib.mkOption {
        type = options.services.uwsgi.instance.type;
        default = { http = ":8080"; };
        example = lib.literalExpression ''
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

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.users.searx =
      { description = "Searx daemon user";
        group = "searx";
        isSystemUser = true;
      };

    users.groups.searx = { };

    systemd.services.searx-init = {
      description = "Initialise Searx settings";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "searx";
        RuntimeDirectory = "searx";
        RuntimeDirectoryMode = "750";
      } // lib.optionalAttrs (cfg.environmentFile != null)
        { EnvironmentFile = builtins.toPath cfg.environmentFile; };
      script = generateConfig;
    };

    systemd.services.searx = lib.mkIf (!cfg.runInUwsgi) {
      description = "Searx server, the meta search engine.";
      wantedBy = [ "network.target" "multi-user.target" ];
      requires = [ "searx-init.service" ];
      after = [ "searx-init.service" ];
      serviceConfig = {
        User  = "searx";
        Group = "searx";
        ExecStart = lib.getExe cfg.package;
      } // lib.optionalAttrs (cfg.environmentFile != null)
        { EnvironmentFile = builtins.toPath cfg.environmentFile; };
      environment = {
        SEARX_SETTINGS_PATH = cfg.settingsFile;
        SEARXNG_SETTINGS_PATH = cfg.settingsFile;
      };
    };

    systemd.services.uwsgi = lib.mkIf cfg.runInUwsgi {
      requires = [ "searx-init.service" ];
      after = [ "searx-init.service" ];
    };

    services.searx.settings = {
      # merge NixOS settings with defaults settings.yml
      use_default_settings = lib.mkDefault true;
      redis.url = lib.mkIf cfg.redisCreateLocally "unix://${config.services.redis.servers.searx.unixSocket}";
    };

    services.uwsgi = lib.mkIf cfg.runInUwsgi {
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
          # TODO: drop this as it is only required for searx
          "SEARX_SETTINGS_PATH=${cfg.settingsFile}"
          # searxng compatibility https://github.com/searxng/searxng/issues/1519
          "SEARXNG_SETTINGS_PATH=${cfg.settingsFile}"
        ];
        buffer-size = 32768;
        pythonPackages = self: [ cfg.package ];
      } // cfg.uwsgiConfig;
    };

    services.redis.servers.searx = lib.mkIf cfg.redisCreateLocally {
      enable = true;
      user = "searx";
      port = 0;
    };

    environment.etc."searxng/limiter.toml" = lib.mkIf (cfg.limiterSettings != { }) {
      source = limiterSettingsFile;
    };
  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj _999eagle ];
}
