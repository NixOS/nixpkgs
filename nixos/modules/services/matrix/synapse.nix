{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.matrix-synapse;
  format = pkgs.formats.yaml { };

  filterRecursiveNull = o:
    if isAttrs o then
      mapAttrs (_: v: filterRecursiveNull v) (filterAttrs (_: v: v != null) o)
    else if isList o then
      map filterRecursiveNull (filter (v: v != null) o)
    else
      o;

  # remove null values from the final configuration
  finalSettings = filterRecursiveNull cfg.settings;
  configFile = format.generate "homeserver.yaml" finalSettings;

  usePostgresql = cfg.settings.database.name == "psycopg2";
  hasLocalPostgresDB = let args = cfg.settings.database.args; in
    usePostgresql
    && (!(args ? host) || (elem args.host [ "localhost" "127.0.0.1" "::1" ]))
    && config.services.postgresql.enable;
  hasWorkers = cfg.workers != { };

  listenerSupportsResource = resource: listener:
    lib.any ({ names, ... }: builtins.elem resource names) listener.resources;

  clientListener = findFirst
    (listenerSupportsResource "client")
    null
    (cfg.settings.listeners
      ++ concatMap ({ worker_listeners, ... }: worker_listeners) (attrValues cfg.workers));

  registerNewMatrixUser =
    let
      isIpv6 = hasInfix ":";

      # add a tail, so that without any bind_addresses we still have a useable address
      bindAddress = head (clientListener.bind_addresses ++ [ "127.0.0.1" ]);
      listenerProtocol = if clientListener.tls
        then "https"
        else "http";
    in
    assert assertMsg (clientListener != null) "No client listener found in synapse or one of its workers";
    pkgs.writeShellScriptBin "matrix-synapse-register_new_matrix_user" ''
      exec ${cfg.package}/bin/register_new_matrix_user \
        $@ \
        ${lib.concatMapStringsSep " " (x: "-c ${x}") ([ configFile ] ++ cfg.extraConfigFiles)} \
        "${listenerProtocol}://${
          if (isIpv6 bindAddress) then
            "[${bindAddress}]"
          else
            "${bindAddress}"
        }:${builtins.toString clientListener.port}/"
    '';

  defaultExtras = [
    "systemd"
    "postgres"
    "url-preview"
    "user-search"
  ];

  wantedExtras = cfg.extras
    ++ lib.optional (cfg.settings ? oidc_providers) "oidc"
    ++ lib.optional (cfg.settings ? jwt_config) "jwt"
    ++ lib.optional (cfg.settings ? saml2_config) "saml2"
    ++ lib.optional (cfg.settings ? redis) "redis"
    ++ lib.optional (cfg.settings ? sentry) "sentry"
    ++ lib.optional (cfg.settings ? user_directory) "user-search"
    ++ lib.optional (cfg.settings.url_preview_enabled) "url-preview"
    ++ lib.optional (cfg.settings.database.name == "psycopg2") "postgres";

  wrapped = pkgs.matrix-synapse.override {
    extras = wantedExtras;
    inherit (cfg) plugins;
  };

  defaultCommonLogConfig = {
    version = 1;
    formatters.journal_fmt.format = "%(name)s: [%(request)s] %(message)s";
    handlers.journal = {
      class = "systemd.journal.JournalHandler";
      formatter = "journal_fmt";
    };
    root = {
      level = "INFO";
      handlers = [ "journal" ];
    };
    disable_existing_loggers = false;
  };

  defaultCommonLogConfigText = generators.toPretty { } defaultCommonLogConfig;

  logConfigText = logName:
    lib.literalMD ''
      Path to a yaml file generated from this Nix expression:

      ```
      ${generators.toPretty { } (
        recursiveUpdate defaultCommonLogConfig { handlers.journal.SYSLOG_IDENTIFIER = logName; }
      )}
      ```
    '';

  genLogConfigFile = logName: format.generate
    "synapse-log-${logName}.yaml"
    (cfg.log // optionalAttrs (cfg.log?handlers.journal) {
      handlers.journal = cfg.log.handlers.journal // {
        SYSLOG_IDENTIFIER = logName;
      };
    });

  toIntBase8 = str:
    lib.pipe str [
      lib.stringToCharacters
      (map lib.toInt)
      (lib.foldl (acc: digit: acc * 8 + digit) 0)
    ];

  toDecimalFilePermission = value:
    if value == null then
      null
    else
      toIntBase8 value;
in {

  imports = [

    (mkRemovedOptionModule [ "services" "matrix-synapse" "trusted_third_party_id_servers" ] ''
      The `trusted_third_party_id_servers` option as been removed in `matrix-synapse` v1.4.0
      as the behavior is now obsolete.
    '')
    (mkRemovedOptionModule [ "services" "matrix-synapse" "create_local_database" ] ''
      Database configuration must be done manually. An exemplary setup is demonstrated in
      <nixpkgs/nixos/tests/matrix/synapse.nix>
    '')
    (mkRemovedOptionModule [ "services" "matrix-synapse" "web_client" ] "")
    (mkRemovedOptionModule [ "services" "matrix-synapse" "room_invite_state_types" ] ''
      You may add additional event types via
      `services.matrix-synapse.room_prejoin_state.additional_event_types` and
      disable the default events via
      `services.matrix-synapse.room_prejoin_state.disable_default_event_types`.
    '')

    # options that don't exist in synapse anymore
    (mkRemovedOptionModule [ "services" "matrix-synapse" "bind_host" ] "Use listener settings instead." )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "bind_port" ] "Use listener settings instead." )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "expire_access_tokens" ] "" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "no_tls" ] "It is no longer supported by synapse." )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "tls_dh_param_path" ] "It was removed from synapse." )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "unsecure_port" ] "Use settings.listeners instead." )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "user_creation_max_duration" ] "It is no longer supported by synapse." )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "verbose" ] "Use a log config instead." )

    # options that were moved into rfc42 style settings
    (mkRemovedOptionModule [ "services" "matrix-synapse" "app_service_config_files" ] "Use settings.app_service_config_files instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "database_args" ] "Use settings.database.args instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "database_name" ] "Use settings.database.args.database instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "database_type" ] "Use settings.database.name instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "database_user" ] "Use settings.database.args.user instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "dynamic_thumbnails" ] "Use settings.dynamic_thumbnails instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "enable_metrics" ] "Use settings.enable_metrics instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "enable_registration" ] "Use settings.enable_registration instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "extraConfig" ] "Use settings instead." )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "listeners" ] "Use settings.listeners instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "logConfig" ] "Use settings.log_config instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "max_image_pixels" ] "Use settings.max_image_pixels instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "max_upload_size" ] "Use settings.max_upload_size instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "presence" "enabled" ] "Use settings.presence.enabled instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "public_baseurl" ] "Use settings.public_baseurl instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "report_stats" ] "Use settings.report_stats instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "server_name" ] "Use settings.server_name instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "servers" ] "Use settings.trusted_key_servers instead." )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "tls_certificate_path" ] "Use settings.tls_certificate_path instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "tls_private_key_path" ] "Use settings.tls_private_key_path instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "turn_shared_secret" ] "Use settings.turn_shared_secret instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "turn_uris" ] "Use settings.turn_uris instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "turn_user_lifetime" ] "Use settings.turn_user_lifetime instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "url_preview_enabled" ] "Use settings.url_preview_enabled instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "url_preview_ip_range_blacklist" ] "Use settings.url_preview_ip_range_blacklist instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "url_preview_ip_range_whitelist" ] "Use settings.url_preview_ip_range_whitelist instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "url_preview_url_blacklist" ] "Use settings.url_preview_url_blacklist instead" )

    # options that are too specific to mention them explicitly in settings
    (mkRemovedOptionModule [ "services" "matrix-synapse" "account_threepid_delegates" "email" ] "Use settings.account_threepid_delegates.email instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "account_threepid_delegates" "msisdn" ] "Use settings.account_threepid_delegates.msisdn instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "allow_guest_access" ] "Use settings.allow_guest_access instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "bcrypt_rounds" ] "Use settings.bcrypt_rounds instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "enable_registration_captcha" ] "Use settings.enable_registration_captcha instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "event_cache_size" ] "Use settings.event_cache_size instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "federation_rc_concurrent" ] "Use settings.rc_federation.concurrent instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "federation_rc_reject_limit" ] "Use settings.rc_federation.reject_limit instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "federation_rc_sleep_delay" ] "Use settings.rc_federation.sleep_delay instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "federation_rc_sleep_limit" ] "Use settings.rc_federation.sleep_limit instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "federation_rc_window_size" ] "Use settings.rc_federation.window_size instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "key_refresh_interval" ] "Use settings.key_refresh_interval instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "rc_messages_burst_count" ] "Use settings.rc_messages.burst_count instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "rc_messages_per_second" ] "Use settings.rc_messages.per_second instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "recaptcha_private_key" ] "Use settings.recaptcha_private_key instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "recaptcha_public_key" ] "Use settings.recaptcha_public_key instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "redaction_retention_period" ] "Use settings.redaction_retention_period instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "room_prejoin_state" "additional_event_types" ] "Use settings.room_prejoin_state.additional_event_types instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "room_prejoin_state" "disable_default_event_types" ] "Use settings.room_prejoin-state.disable_default_event_types instead" )

    # Options that should be passed via extraConfigFiles, so they are not persisted into the nix store
    (mkRemovedOptionModule [ "services" "matrix-synapse" "macaroon_secret_key" ] "Pass this value via extraConfigFiles instead" )
    (mkRemovedOptionModule [ "services" "matrix-synapse" "registration_shared_secret" ] "Pass this value via extraConfigFiles instead" )

  ];

  options = let
    listenerType = workerContext: types.submodule ({ config, ... }: {
      options = {
        port = mkOption {
          type = types.nullOr types.port;
          default = null;
          example = 8448;
          description = ''
            The port to listen for HTTP(S) requests on.
          '';
        };

        bind_addresses = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = if config.path != null then null else [
            "::1"
            "127.0.0.1"
          ];
          defaultText = literalExpression ''
            if path != null then
              null
            else
              [
                "::1"
                "127.0.0.1"
              ]
          '';
          example = literalExpression ''
            [
              "::"
              "0.0.0.0"
            ]
          '';
          description = ''
            IP addresses to bind the listener to.
          '';
        };

        path = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Unix domain socket path to bind this listener to.

            ::: {.note}
              This option is incompatible with {option}`bind_addresses`, {option}`port`, {option}`tls`
              and also does not support the `metrics` and `manhole` listener {option}`type`.
            :::
          '';
        };

        mode = mkOption {
          type = types.nullOr (types.strMatching "^[0,2-7]{3,4}$");
          default = if config.path != null then "660" else null;
          defaultText = literalExpression ''
            if path != null then
              "660"
            else
              null
          '';
          example = "660";
          description = ''
            File permissions on the UNIX domain socket.
          '';
          apply = toDecimalFilePermission;
        };

        type = mkOption {
          type = types.enum [
            "http"
            "manhole"
            "metrics"
            "replication"
          ];
          default = "http";
          example = "metrics";
          description = ''
            The type of the listener, usually http.
          '';
        };

        tls = mkOption {
          type = types.nullOr types.bool;
          default = if config.path != null then
            null
          else
            !workerContext;
          defaultText = ''
            Enabled for the main instance listener, unless it is configured with a UNIX domain socket path.
          '';
          example = false;
          description = ''
            Whether to enable TLS on the listener socket.

            ::: {.note}
              This option will be ignored for UNIX domain sockets.
            :::
          '';
        };

        x_forwarded = mkOption {
          type = types.bool;
          default = config.path != null;
          defaultText = ''
            Enabled if the listener is configured with a UNIX domain socket path
          '';
          example = true;
          description = ''
            Use the X-Forwarded-For (XFF) header as the client IP and not the
            actual client IP.
          '';
        };

        resources = mkOption {
          type = types.listOf (types.submodule {
            options = {
              names = mkOption {
                type = types.listOf (types.enum [
                  "client"
                  "consent"
                  "federation"
                  "health"
                  "keys"
                  "media"
                  "metrics"
                  "openid"
                  "replication"
                  "static"
                ]);
                description = ''
                  List of resources to host on this listener.
                '';
                example = [
                  "client"
                ];
              };
              compress = mkOption {
                default = false;
                type = types.bool;
                description = ''
                  Whether synapse should compress HTTP responses to clients that support it.
                  This should be disabled if running synapse behind a load balancer
                  that can do automatic compression.
                '';
              };
            };
          });
          description = ''
            List of HTTP resources to serve on this listener.
          '';
        };
      };
    });
  in {
    services.matrix-synapse = {
      enable = mkEnableOption "matrix.org synapse, the reference homeserver";

      enableRegistrationScript = mkOption {
        type = types.bool;
        default = clientListener.bind_addresses != [];
        example = false;
        defaultText = ''
          Enabled if the client listener uses TCP sockets
        '';
        description = ''
          Whether to install the `register_new_matrix_user` script, that
          allows account creation on the terminal.

          ::: {.note}
            This script does not work when the client listener uses UNIX domain sockets
          :::
        '';
      };

      serviceUnit = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        description = ''
          The systemd unit (a service or a target) for other services to depend on if they
          need to be started after matrix-synapse.

          This option is useful as the actual parent unit for all matrix-synapse processes
          changes when configuring workers.
        '';
      };

      configFile = mkOption {
        type = types.path;
        readOnly = true;
        description = ''
          Path to the configuration file on the target system. Useful to configure e.g. workers
          that also need this.
        '';
      };

      package = mkOption {
        type = types.package;
        readOnly = true;
        description = ''
          Reference to the `matrix-synapse` wrapper with all extras
          (e.g. for `oidc` or `saml2`) added to the `PYTHONPATH` of all executables.

          This option is useful to reference the "final" `matrix-synapse` package that's
          actually used by `matrix-synapse.service`. For instance, when using
          workers, it's possible to run
          `''${config.services.matrix-synapse.package}/bin/synapse_worker` and
          no additional PYTHONPATH needs to be specified for extras or plugins configured
          via `services.matrix-synapse`.

          However, this means that this option is supposed to be only declared
          by the `services.matrix-synapse` module itself and is thus read-only.
          In order to modify `matrix-synapse` itself, use an overlay to override
          `pkgs.matrix-synapse-unwrapped`.
        '';
      };

      extras = mkOption {
        type = types.listOf (types.enum (lib.attrNames pkgs.matrix-synapse-unwrapped.optional-dependencies));
        default = defaultExtras;
        example = literalExpression ''
          [
            "cache-memory" # Provide statistics about caching memory consumption
            "jwt"          # JSON Web Token authentication
            "oidc"         # OpenID Connect authentication
            "postgres"     # PostgreSQL database backend
            "redis"        # Redis support for the replication stream between worker processes
            "saml2"        # SAML2 authentication
            "sentry"       # Error tracking and performance metrics
            "systemd"      # Provide the JournalHandler used in the default log_config
            "url-preview"  # Support for oEmbed URL previews
            "user-search"  # Support internationalized domain names in user-search
          ]
        '';
        description = ''
          Explicitly install extras provided by matrix-synapse. Most
          will require some additional configuration.

          Extras will automatically be enabled, when the relevant
          configuration sections are present.

          Please note that this option is additive: i.e. when adding a new item
          to this list, the defaults are still kept. To override the defaults as well,
          use `lib.mkForce`.
        '';
      };

      plugins = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExpression ''
          with config.services.matrix-synapse.package.plugins; [
            matrix-synapse-ldap3
            matrix-synapse-pam
          ];
        '';
        description = ''
          List of additional Matrix plugins to make available.
        '';
      };

      withJemalloc = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to preload jemalloc to reduce memory fragmentation and overall usage.
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/matrix-synapse";
        description = ''
          The directory where matrix-synapse stores its stateful data such as
          certificates, media and uploads.
        '';
      };

      log = mkOption {
        type = types.attrsOf format.type;
        defaultText = literalExpression defaultCommonLogConfigText;
        description = ''
          Default configuration for the loggers used by `matrix-synapse` and its workers.
          The defaults are added with the default priority which means that
          these will be merged with additional declarations. These additional
          declarations also take precedence over the defaults when declared
          with at least normal priority. For instance
          the log-level for synapse and its workers can be changed like this:

          ```nix
          { lib, ... }: {
            services.matrix-synapse.log.root.level = "WARNING";
          }
          ```

          And another field can be added like this:

          ```nix
          {
            services.matrix-synapse.log = {
              loggers."synapse.http.matrixfederationclient".level = "DEBUG";
            };
          }
          ```

          Additionally, the field `handlers.journal.SYSLOG_IDENTIFIER` will be added to
          each log config, i.e.
          * `synapse` for `matrix-synapse.service`
          * `synapse-<worker name>` for `matrix-synapse-worker-<worker name>.service`

          This is only done if this option has a `handlers.journal` field declared.

          To discard all settings declared by this option for each worker and synapse,
          `lib.mkForce` can be used.

          To discard all settings declared by this option for a single worker or synapse only,
          [](#opt-services.matrix-synapse.workers._name_.worker_log_config) or
          [](#opt-services.matrix-synapse.settings.log_config) can be used.
        '';
      };

      settings = mkOption {
        default = { };
        description = ''
          The primary synapse configuration. See the
          [sample configuration](https://github.com/element-hq/synapse/blob/v${pkgs.matrix-synapse-unwrapped.version}/docs/sample_config.yaml)
          for possible values.

          Secrets should be passed in by using the `extraConfigFiles` option.
        '';
        type = with types; submodule {
          freeformType = format.type;
          options = {
            # This is a reduced set of popular options and defaults
            # Do not add every available option here, they can be specified
            # by the user at their own discretion. This is a freeform type!

            server_name = mkOption {
              type = types.str;
              example = "example.com";
              default = config.networking.hostName;
              defaultText = literalExpression "config.networking.hostName";
              description = ''
                The domain name of the server, with optional explicit port.
                This is used by remote servers to look up the server address.
                This is also the last part of your UserID.

                The server_name cannot be changed later so it is important to configure this correctly before you start Synapse.
              '';
            };

            enable_registration = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Enable registration for new users.
              '';
            };

            registration_shared_secret = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                If set, allows registration by anyone who also has the shared
                secret, even if registration is otherwise disabled.

                Secrets should be passed in via `extraConfigFiles`!
              '';
            };

            macaroon_secret_key = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                Secret key for authentication tokens. If none is specified,
                the registration_shared_secret is used, if one is given; otherwise,
                a secret key is derived from the signing key.

                Secrets should be passed in via `extraConfigFiles`!
              '';
            };

            enable_metrics = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Enable collection and rendering of performance metrics
              '';
            };

            report_stats = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Whether or not to report anonymized homeserver usage statistics.
              '';
            };

            signing_key_path = mkOption {
              type = types.path;
              default = "${cfg.dataDir}/homeserver.signing.key";
              description = ''
                Path to the signing key to sign messages with.
              '';
            };

            pid_file = mkOption {
              type = types.path;
              default = "/run/matrix-synapse.pid";
              readOnly = true;
              description = ''
                The file to store the PID in.
              '';
            };

            log_config = mkOption {
              type = types.path;
              default = genLogConfigFile "synapse";
              defaultText = logConfigText "synapse";
              description = ''
                The file that holds the logging configuration.
              '';
            };

            media_store_path = mkOption {
              type = types.path;
              default = if lib.versionAtLeast config.system.stateVersion "22.05"
                then "${cfg.dataDir}/media_store"
                else "${cfg.dataDir}/media";
              defaultText = "${cfg.dataDir}/media_store for when system.stateVersion is at least 22.05, ${cfg.dataDir}/media when lower than 22.05";
              description = ''
                Directory where uploaded images and attachments are stored.
              '';
            };

            public_baseurl = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "https://example.com:8448/";
              description = ''
                The public-facing base URL for the client API (not including _matrix/...)
              '';
            };

            tls_certificate_path = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "/var/lib/acme/example.com/fullchain.pem";
              description = ''
                PEM encoded X509 certificate for TLS.
                You can replace the self-signed certificate that synapse
                autogenerates on launch with your own SSL certificate + key pair
                if you like.  Any required intermediary certificates can be
                appended after the primary certificate in hierarchical order.
              '';
            };

            tls_private_key_path = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "/var/lib/acme/example.com/key.pem";
              description = ''
                PEM encoded private key for TLS. Specify null if synapse is not
                speaking TLS directly.
              '';
            };

            presence.enabled = mkOption {
              type = types.bool;
              default = true;
              example = false;
              description = ''
                Whether to enable presence tracking.

                Presence tracking allows users to see the state (e.g online/offline)
                of other local and remote users.
              '';
            };

            listeners = mkOption {
              type = types.listOf (listenerType false);
              default = [{
                port = 8008;
                bind_addresses = [ "127.0.0.1" ];
                type = "http";
                tls = false;
                x_forwarded = true;
                resources = [{
                  names = [ "client" ];
                  compress = true;
                } {
                  names = [ "federation" ];
                  compress = false;
                }];
              }] ++ lib.optional hasWorkers {
                path = "/run/matrix-synapse/main_replication.sock";
                type = "http";
                resources = [{
                  names = [ "replication" ];
                  compress = false;
                }];
              };
              description = ''
                List of ports that Synapse should listen on, their purpose and their configuration.

                By default, synapse will be configured for client and federation traffic on port 8008, and
                use a UNIX domain socket for worker replication. See [`services.matrix-synapse.workers`](#opt-services.matrix-synapse.workers)
                for more details.
              '';
            };

            database.name = mkOption {
              type = types.enum [
                "sqlite3"
                "psycopg2"
              ];
              default = if versionAtLeast config.system.stateVersion "18.03"
                then "psycopg2"
                else "sqlite3";
              defaultText = literalExpression ''
                if versionAtLeast config.system.stateVersion "18.03"
                then "psycopg2"
                else "sqlite3"
              '';
              description = ''
                The database engine name. Can be sqlite3 or psycopg2.
              '';
            };

            database.args.database = mkOption {
              type = types.str;
              default = {
                sqlite3 = "${cfg.dataDir}/homeserver.db";
                psycopg2 = "matrix-synapse";
              }.${cfg.settings.database.name};
              defaultText = literalExpression ''
                {
                  sqlite3 = "''${${options.services.matrix-synapse.dataDir}}/homeserver.db";
                  psycopg2 = "matrix-synapse";
                }.''${${options.services.matrix-synapse.settings}.database.name};
              '';
              description = ''
                Name of the database when using the psycopg2 backend,
                path to the database location when using sqlite3.
              '';
            };

            database.args.user = mkOption {
              type = types.nullOr types.str;
              default = {
                sqlite3 = null;
                psycopg2 = "matrix-synapse";
              }.${cfg.settings.database.name};
              defaultText = lib.literalExpression ''
                {
                  sqlite3 = null;
                  psycopg2 = "matrix-synapse";
                }.''${cfg.settings.database.name};
              '';
              description = ''
                Username to connect with psycopg2, set to null
                when using sqlite3.
              '';
            };

            url_preview_enabled = mkOption {
              type = types.bool;
              default = true;
              example = false;
              description = ''
                Is the preview URL API enabled?  If enabled, you *must* specify an
                explicit url_preview_ip_range_blacklist of IPs that the spider is
                denied from accessing.
              '';
            };

            url_preview_ip_range_blacklist = mkOption {
              type = types.listOf types.str;
              default = [
                "10.0.0.0/8"
                "100.64.0.0/10"
                "127.0.0.0/8"
                "169.254.0.0/16"
                "172.16.0.0/12"
                "192.0.0.0/24"
                "192.0.2.0/24"
                "192.168.0.0/16"
                "192.88.99.0/24"
                "198.18.0.0/15"
                "198.51.100.0/24"
                "2001:db8::/32"
                "203.0.113.0/24"
                "224.0.0.0/4"
                "::1/128"
                "fc00::/7"
                "fe80::/10"
                "fec0::/10"
                "ff00::/8"
              ];
              description = ''
                List of IP address CIDR ranges that the URL preview spider is denied
                from accessing.
              '';
            };

            url_preview_ip_range_whitelist = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = ''
                List of IP address CIDR ranges that the URL preview spider is allowed
                to access even if they are specified in url_preview_ip_range_blacklist.
              '';
            };

            url_preview_url_blacklist = mkOption {
              # FIXME revert to just `listOf (attrsOf str)` after some time(tm).
              type = types.listOf (
                types.coercedTo
                  types.str
                  (const (throw ''
                    Setting `config.services.matrix-synapse.settings.url_preview_url_blacklist`
                    to a list of strings has never worked. Due to a bug, this was the type accepted
                    by the module, but in practice it broke on runtime and as a result, no URL
                    preview worked anywhere if this was set.

                    See https://element-hq.github.io/synapse/latest/usage/configuration/config_documentation.html#url_preview_url_blacklist
                    on how to configure it properly.
                  ''))
                  (types.attrsOf types.str));
              default = [ ];
              example = literalExpression ''
                [
                  { scheme = "http"; } # no http previews
                  { netloc = "www.acme.com"; path = "/foo"; } # block http(s)://www.acme.com/foo
                ]
              '';
              description = ''
                Optional list of URL matches that the URL preview spider is
                denied from accessing.
              '';
            };

            max_upload_size = mkOption {
              type = types.str;
              default = "50M";
              example = "100M";
              description = ''
                The largest allowed upload size in bytes
              '';
            };

            max_image_pixels = mkOption {
              type = types.str;
              default = "32M";
              example = "64M";
              description = ''
                Maximum number of pixels that will be thumbnailed
              '';
            };

            dynamic_thumbnails = mkOption {
              type = types.bool;
              default = false;
              example = true;
              description = ''
                Whether to generate new thumbnails on the fly to precisely match
                the resolution requested by the client. If true then whenever
                a new resolution is requested by the client the server will
                generate a new thumbnail. If false the server will pick a thumbnail
                from a precalculated list.
              '';
            };

            turn_uris = mkOption {
              type = types.listOf types.str;
              default = [ ];
              example = [
                "turn:turn.example.com:3487?transport=udp"
                "turn:turn.example.com:3487?transport=tcp"
                "turns:turn.example.com:5349?transport=udp"
                "turns:turn.example.com:5349?transport=tcp"
              ];
              description = ''
                The public URIs of the TURN server to give to clients
              '';
            };
            turn_shared_secret = mkOption {
              type = types.str;
              default = "";
              example = literalExpression ''
                config.services.coturn.static-auth-secret
              '';
              description = ''
                The shared secret used to compute passwords for the TURN server.

                Secrets should be passed in via `extraConfigFiles`!
              '';
            };

            trusted_key_servers = mkOption {
              type = types.listOf (types.submodule {
                freeformType = format.type;
                options = {
                  server_name = mkOption {
                    type = types.str;
                    example = "matrix.org";
                    description = ''
                      Hostname of the trusted server.
                    '';
                  };
                };
              });
              default = [{
                server_name = "matrix.org";
                verify_keys = {
                  "ed25519:auto" = "Noi6WqcDj0QmPxCNQqgezwTlBKrfqehY1u2FyWP9uYw";
                };
              }];
              description = ''
                The trusted servers to download signing keys from.
              '';
            };

            app_service_config_files = mkOption {
              type = types.listOf types.path;
              default = [ ];
              description = ''
                A list of application service config file to use
              '';
            };

            redis = lib.mkOption {
              type = types.submodule {
                freeformType = format.type;
                options = {
                  enabled = lib.mkOption {
                    type = types.bool;
                    default = false;
                    description = ''
                      Whether to use redis support
                    '';
                  };
                };
              };
              default = { };
              description = ''
                Redis configuration for synapse.

                See the
                [upstream documentation](https://github.com/element-hq/synapse/blob/v${pkgs.matrix-synapse-unwrapped.version}/docs/usage/configuration/config_documentation.md#redis)
                for available options.
              '';
            };
          };
        };
      };

      workers = lib.mkOption {
        default = { };
        description = ''
          Options for configuring workers. Worker support will be enabled if at least one worker is configured here.

          See the [worker documention](https://element-hq.github.io/synapse/latest/workers.html#worker-configuration)
          for possible options for each worker. Worker-specific options overriding the shared homeserver configuration can be
          specified here for each worker.

          ::: {.note}
            Worker support will add a replication listener on port 9093 to the main synapse process using the default
            value of [`services.matrix-synapse.settings.listeners`](#opt-services.matrix-synapse.settings.listeners) and configure that
            listener as `services.matrix-synapse.settings.instance_map.main`.
            If you set either of those options, make sure to configure a replication listener yourself.

            A redis server is required for running workers. A local one can be enabled
            using [`services.matrix-synapse.configureRedisLocally`](#opt-services.matrix-synapse.configureRedisLocally).

            Workers also require a proper reverse proxy setup to direct incoming requests to the appropriate process. See
            the [reverse proxy documentation](https://element-hq.github.io/synapse/latest/reverse_proxy.html) for a
            general reverse proxying setup and
            the [worker documentation](https://element-hq.github.io/synapse/latest/workers.html#available-worker-applications)
            for the available endpoints per worker application.
          :::
        '';
        type = types.attrsOf (types.submodule ({name, ...}: {
          freeformType = format.type;
          options = {
            worker_app = lib.mkOption {
              type = types.enum [
                "synapse.app.generic_worker"
                "synapse.app.media_repository"
              ];
              description = "Type of this worker";
              default = "synapse.app.generic_worker";
            };
            worker_listeners = lib.mkOption {
              default = [ ];
              type = types.listOf (listenerType true);
              description = ''
                List of ports that this worker should listen on, their purpose and their configuration.
              '';
            };
            worker_log_config = lib.mkOption {
              type = types.path;
              default = genLogConfigFile "synapse-${name}";
              defaultText = logConfigText "synapse-${name}";
              description = ''
                The file for log configuration.

                See the [python documentation](https://docs.python.org/3/library/logging.config.html#configuration-dictionary-schema)
                for the schema and the [upstream repository](https://github.com/element-hq/synapse/blob/v${pkgs.matrix-synapse-unwrapped.version}/docs/sample_log_config.yaml)
                for an example.
              '';
            };
          };
        }));
        default = { };
        example = lib.literalExpression ''
          {
            "federation_sender" = { };
            "federation_receiver" = {
              worker_listeners = [
                {
                  type = "http";
                  port = 8009;
                  bind_addresses = [ "127.0.0.1" ];
                  tls = false;
                  x_forwarded = true;
                  resources = [{
                    names = [ "federation" ];
                  }];
                }
              ];
            };
          }
        '';
      };

      extraConfigFiles = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = ''
          Extra config files to include.

          The configuration files will be included based on the command line
          argument --config-path. This allows to configure secrets without
          having to go through the Nix store, e.g. based on deployment keys if
          NixOps is in use.
        '';
      };

      configureRedisLocally = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to automatically configure a local redis server for matrix-synapse.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = clientListener != null;
        message = ''
          At least one listener which serves the `client` resource via HTTP is required
          by synapse in `services.matrix-synapse.settings.listeners` or in one of the workers!
        '';
      }
      {
        assertion = hasWorkers -> cfg.settings.redis.enabled;
        message = ''
          Workers for matrix-synapse require configuring a redis instance. This can be done
          automatically by setting `services.matrix-synapse.configureRedisLocally = true`.
        '';
      }
      {
        assertion =
          let
            main = cfg.settings.instance_map.main;
            listener = lib.findFirst
              (
                listener:
                  (
                    lib.hasAttr "port" main && listener.port or null == main.port
                    || lib.hasAttr "path" main && listener.path or null == main.path
                  )
                  && listenerSupportsResource "replication" listener
                  && (
                    lib.hasAttr "host" main &&  lib.any (bind: bind == main.host || bind == "0.0.0.0" || bind == "::") listener.bind_addresses
                    || lib.hasAttr "path" main
                  )
              )
              null
              cfg.settings.listeners;
          in
          hasWorkers -> (cfg.settings.instance_map ? main && listener != null);
        message = ''
          Workers for matrix-synapse require setting `services.matrix-synapse.settings.instance_map.main`
          to any listener configured in `services.matrix-synapse.settings.listeners` with a `"replication"`
          resource.

          This is done by default unless you manually configure either of those settings.
        '';
      }
      {
        assertion = cfg.enableRegistrationScript -> clientListener.path == null;
        message = ''
          The client listener on matrix-synapse is configured to use UNIX domain sockets.
          This configuration is incompatible with the `register_new_matrix_user` script.

          Disable  `services.matrix-synapse.enableRegistrationScript` to continue.
        '';
      }
    ]
    ++ (map (listener: {
      assertion = (listener.path == null) != (listener.bind_addresses == null);
      message = ''
        Listeners require either a UNIX domain socket `path` or `bind_addresses` for a TCP socket.
      '';
    }) cfg.settings.listeners)
    ++ (map (listener: {
      assertion = listener.path != null -> (listener.bind_addresses == null && listener.port == null && listener.tls == null);
      message = let
        formatKeyValue = key: value: lib.optionalString (value != null) "  - ${key}=${toString value}\n";
      in ''
        Listener configured with UNIX domain socket (${toString listener.path}) ignores the following options:
        ${formatKeyValue "bind_addresses" listener.bind_addresses}${formatKeyValue "port" listener.port}${formatKeyValue "tls" listener.tls}
      '';
    }) cfg.settings.listeners)
    ++ (map (listener: {
      assertion = listener.path == null || listener.type == "http";
      message = ''
        Listener configured with UNIX domain socket (${toString listener.path}) only supports the "http" listener type.
      '';
    }) cfg.settings.listeners);

    services.matrix-synapse.settings.redis = lib.mkIf cfg.configureRedisLocally {
      enabled = true;
      path = config.services.redis.servers.matrix-synapse.unixSocket;
    };
    services.matrix-synapse.settings.instance_map.main = lib.mkIf hasWorkers (lib.mkDefault {
      path = "/run/matrix-synapse/main_replication.sock";
    });

    services.matrix-synapse.serviceUnit = if hasWorkers then "matrix-synapse.target" else "matrix-synapse.service";
    services.matrix-synapse.configFile = configFile;
    services.matrix-synapse.package = wrapped;

    # default them, so they are additive
    services.matrix-synapse.extras = defaultExtras;

    services.matrix-synapse.log = mapAttrsRecursive (const mkDefault) defaultCommonLogConfig;

    users.users.matrix-synapse = {
      group = "matrix-synapse";
      home = cfg.dataDir;
      createHome = true;
      shell = "${pkgs.bash}/bin/bash";
      uid = config.ids.uids.matrix-synapse;
    };

    users.groups.matrix-synapse = {
      gid = config.ids.gids.matrix-synapse;
    };

    systemd.targets.matrix-synapse = lib.mkIf hasWorkers {
      description = "Synapse Matrix parent target";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ] ++ optional hasLocalPostgresDB "postgresql.service";
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services =
      let
        targetConfig =
          if hasWorkers
          then {
            partOf = [ "matrix-synapse.target" ];
            wantedBy = [ "matrix-synapse.target" ];
            unitConfig.ReloadPropagatedFrom = "matrix-synapse.target";
            requires = optional hasLocalPostgresDB "postgresql.service";
          }
          else {
            wants = [ "network-online.target" ];
            after = [ "network-online.target" ] ++ optional hasLocalPostgresDB "postgresql.service";
            requires = optional hasLocalPostgresDB "postgresql.service";
            wantedBy = [ "multi-user.target" ];
          };
        baseServiceConfig = {
          environment = optionalAttrs (cfg.withJemalloc) {
            LD_PRELOAD = "${pkgs.jemalloc}/lib/libjemalloc.so";
          };
          serviceConfig = {
            Type = "notify";
            User = "matrix-synapse";
            Group = "matrix-synapse";
            WorkingDirectory = cfg.dataDir;
            RuntimeDirectory = "matrix-synapse";
            RuntimeDirectoryPreserve = true;
            ExecReload = "${pkgs.util-linux}/bin/kill -HUP $MAINPID";
            Restart = "on-failure";
            UMask = "0077";

            # Security Hardening
            # Refer to systemd.exec(5) for option descriptions.
            CapabilityBoundingSet = [ "" ];
            LockPersonality = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            PrivateUsers = true;
            ProcSubset = "pid";
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            ReadWritePaths = [ cfg.dataDir cfg.settings.media_store_path ] ++
              (map (listener: dirOf listener.path) (filter (listener: listener.path != null) cfg.settings.listeners));
            RemoveIPC = true;
            RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" ];
          };
        }
        // targetConfig;
        genWorkerService = name: workerCfg:
          let
            finalWorkerCfg = workerCfg // { worker_name = name; };
            workerConfigFile = format.generate "worker-${name}.yaml" finalWorkerCfg;
          in
          {
            name = "matrix-synapse-worker-${name}";
            value = lib.mkMerge [
              baseServiceConfig
              {
                description = "Synapse Matrix worker ${name}";
                # make sure the main process starts first for potential database migrations
                after = [ "matrix-synapse.service" ];
                requires = [ "matrix-synapse.service" ];
                serviceConfig = {
                  ExecStart = ''
                    ${cfg.package}/bin/synapse_worker \
                      ${ concatMapStringsSep "\n  " (x: "--config-path ${x} \\") ([ configFile workerConfigFile ] ++ cfg.extraConfigFiles) }
                      --keys-directory ${cfg.dataDir}
                  '';
                };
              }
            ];
          };
      in
      {
        matrix-synapse = lib.mkMerge [
          baseServiceConfig
          {
            description = "Synapse Matrix homeserver";
            preStart = ''
              ${cfg.package}/bin/synapse_homeserver \
                --config-path ${configFile} \
                --keys-directory ${cfg.dataDir} \
                --generate-keys
            '';
            serviceConfig = {
              ExecStartPre = [
                ("+" + (pkgs.writeShellScript "matrix-synapse-fix-permissions" ''
                  chown matrix-synapse:matrix-synapse ${cfg.settings.signing_key_path}
                  chmod 0600 ${cfg.settings.signing_key_path}
                ''))
              ];
              ExecStart = ''
                ${cfg.package}/bin/synapse_homeserver \
                  ${ concatMapStringsSep "\n  " (x: "--config-path ${x} \\") ([ configFile ] ++ cfg.extraConfigFiles) }
                  --keys-directory ${cfg.dataDir}
              '';
            };
          }
        ];
      }
      // (lib.mapAttrs' genWorkerService cfg.workers);

    services.redis.servers.matrix-synapse = lib.mkIf cfg.configureRedisLocally {
      enable = true;
      user = "matrix-synapse";
    };

    environment.systemPackages = lib.optionals cfg.enableRegistrationScript [
      registerNewMatrixUser
    ];
  };

  meta = {
    buildDocsInSandbox = false;
    doc = ./synapse.md;
    maintainers = teams.matrix.members;
  };

}
