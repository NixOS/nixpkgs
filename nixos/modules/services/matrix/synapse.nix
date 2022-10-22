{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.matrix-synapse;
  format = pkgs.formats.yaml {};

  # remove null values from the final configuration
  finalSettings = lib.filterAttrsRecursive (_: v: v != null) cfg.settings;
  configFile = format.generate "homeserver.yaml" finalSettings;
  logConfigFile = format.generate "log_config.yaml" cfg.logConfig;

  pluginsEnv = cfg.package.python.buildEnv.override {
    extraLibs = cfg.plugins;
  };

  usePostgresql = cfg.settings.database.name == "psycopg2";
  hasLocalPostgresDB = let args = cfg.settings.database.args; in
    usePostgresql && (!(args ? host) || (elem args.host [ "localhost" "127.0.0.1" "::1" ]));

  registerNewMatrixUser =
    let
      isIpv6 = x: lib.length (lib.splitString ":" x) > 1;
      listener =
        lib.findFirst (
          listener: lib.any (
            resource: lib.any (
              name: name == "client"
            ) resource.names
          ) listener.resources
        ) (lib.last cfg.settings.listeners) cfg.settings.listeners;
        # FIXME: Handle cases with missing client listener properly,
        # don't rely on lib.last, this will not work.

      # add a tail, so that without any bind_addresses we still have a useable address
      bindAddress = head (listener.bind_addresses ++ [ "127.0.0.1" ]);
      listenerProtocol = if listener.tls
        then "https"
        else "http";
    in
    pkgs.writeShellScriptBin "matrix-synapse-register_new_matrix_user" ''
      exec ${cfg.package}/bin/register_new_matrix_user \
        $@ \
        ${lib.concatMapStringsSep " " (x: "-c ${x}") ([ configFile ] ++ cfg.extraConfigFiles)} \
        "${listenerProtocol}://${
          if (isIpv6 bindAddress) then
            "[${bindAddress}]"
          else
            "${bindAddress}"
        }:${builtins.toString listener.port}/"
    '';
in {

  imports = [

    (mkRemovedOptionModule [ "services" "matrix-synapse" "trusted_third_party_id_servers" ] ''
      The `trusted_third_party_id_servers` option as been removed in `matrix-synapse` v1.4.0
      as the behavior is now obsolete.
    '')
    (mkRemovedOptionModule [ "services" "matrix-synapse" "create_local_database" ] ''
      Database configuration must be done manually. An exemplary setup is demonstrated in
      <nixpkgs/nixos/tests/matrix-synapse.nix>
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

    # options that were moved into rfc42 style settigns
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

  options = {
    services.matrix-synapse = {
      enable = mkEnableOption (lib.mdDoc "matrix.org synapse");

      configFile = mkOption {
        type = types.path;
        readOnly = true;
        description = lib.mdDoc ''
          Path to the configuration file on the target system. Useful to configure e.g. workers
          that also need this.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.matrix-synapse;
        defaultText = literalExpression "pkgs.matrix-synapse";
        description = lib.mdDoc ''
          Overridable attribute of the matrix synapse server package to use.
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
        description = lib.mdDoc ''
          List of additional Matrix plugins to make available.
        '';
      };

      withJemalloc = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to preload jemalloc to reduce memory fragmentation and overall usage.
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/matrix-synapse";
        description = lib.mdDoc ''
          The directory where matrix-synapse stores its stateful data such as
          certificates, media and uploads.
        '';
      };

      settings = mkOption {
        default = {};
        description = mdDoc ''
          The primary synapse configuration. See the
          [sample configuration](https://github.com/matrix-org/synapse/blob/v${cfg.package.version}/docs/sample_config.yaml)
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
              description = lib.mdDoc ''
                The domain name of the server, with optional explicit port.
                This is used by remote servers to look up the server address.
                This is also the last part of your UserID.

                The server_name cannot be changed later so it is important to configure this correctly before you start Synapse.
              '';
            };

            enable_registration = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                Enable registration for new users.
              '';
            };

            registration_shared_secret = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = mdDoc ''
                If set, allows registration by anyone who also has the shared
                secret, even if registration is otherwise disabled.

                Secrets should be passed in via `extraConfigFiles`!
              '';
            };

            macaroon_secret_key = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = mdDoc ''
                Secret key for authentication tokens. If none is specified,
                the registration_shared_secret is used, if one is given; otherwise,
                a secret key is derived from the signing key.

                Secrets should be passed in via `extraConfigFiles`!
              '';
            };

            enable_metrics = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                Enable collection and rendering of performance metrics
              '';
            };

            report_stats = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                Whether or not to report anonymized homeserver usage statistics.
              '';
            };

            signing_key_path = mkOption {
              type = types.path;
              default = "${cfg.dataDir}/homeserver.signing.key";
              description = lib.mdDoc ''
                Path to the signing key to sign messages with.
              '';
            };

            pid_file = mkOption {
              type = types.path;
              default = "/run/matrix-synapse.pid";
              readOnly = true;
              description = lib.mdDoc ''
                The file to store the PID in.
              '';
            };

            log_config = mkOption {
              type = types.path;
              default = ./synapse-log_config.yaml;
              description = lib.mdDoc ''
                The file that holds the logging configuration.
              '';
            };

            media_store_path = mkOption {
              type = types.path;
              default = if lib.versionAtLeast config.system.stateVersion "22.05"
                then "${cfg.dataDir}/media_store"
                else "${cfg.dataDir}/media";
              defaultText = "${cfg.dataDir}/media_store for when system.stateVersion is at least 22.05, ${cfg.dataDir}/media when lower than 22.05";
              description = lib.mdDoc ''
                Directory where uploaded images and attachments are stored.
              '';
            };

            public_baseurl = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "https://example.com:8448/";
              description = lib.mdDoc ''
                The public-facing base URL for the client API (not including _matrix/...)
              '';
            };

            tls_certificate_path = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "/var/lib/acme/example.com/fullchain.pem";
              description = lib.mdDoc ''
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
              description = lib.mdDoc ''
                PEM encoded private key for TLS. Specify null if synapse is not
                speaking TLS directly.
              '';
            };

            presence.enabled = mkOption {
              type = types.bool;
              default = true;
              example = false;
              description = lib.mdDoc ''
                Whether to enable presence tracking.

                Presence tracking allows users to see the state (e.g online/offline)
                of other local and remote users.
              '';
            };

            listeners = mkOption {
              type = types.listOf (types.submodule {
                options = {
                  port = mkOption {
                    type = types.port;
                    example = 8448;
                    description = lib.mdDoc ''
                      The port to listen for HTTP(S) requests on.
                    '';
                  };

                  bind_addresses = mkOption {
                    type = types.listOf types.str;
                    default = [
                      "::1"
                      "127.0.0.1"
                    ];
                    example = literalExpression ''
                    [
                      "::"
                      "0.0.0.0"
                    ]
                    '';
                    description = lib.mdDoc ''
                     IP addresses to bind the listener to.
                    '';
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
                    description = lib.mdDoc ''
                      The type of the listener, usually http.
                    '';
                  };

                  tls = mkOption {
                    type = types.bool;
                    default = true;
                    example = false;
                    description = lib.mdDoc ''
                      Whether to enable TLS on the listener socket.
                    '';
                  };

                  x_forwarded = mkOption {
                    type = types.bool;
                    default = false;
                    example = true;
                    description = lib.mdDoc ''
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
                            "keys"
                            "media"
                            "metrics"
                            "openid"
                            "replication"
                            "static"
                          ]);
                          description = lib.mdDoc ''
                            List of resources to host on this listener.
                          '';
                          example = [
                            "client"
                          ];
                        };
                        compress = mkOption {
                          type = types.bool;
                          description = lib.mdDoc ''
                            Should synapse compress HTTP responses to clients that support it?
                            This should be disabled if running synapse behind a load balancer
                            that can do automatic compression.
                          '';
                        };
                      };
                    });
                    description = lib.mdDoc ''
                      List of HTTP resources to serve on this listener.
                    '';
                  };
                };
              });
              default = [ {
                port = 8008;
                bind_addresses = [ "127.0.0.1" ];
                type = "http";
                tls = false;
                x_forwarded = true;
                resources = [ {
                  names = [ "client" ];
                  compress = true;
                } {
                  names = [ "federation" ];
                  compress = false;
                } ];
              } ];
              description = lib.mdDoc ''
                List of ports that Synapse should listen on, their purpose and their configuration.
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
              description = lib.mdDoc ''
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
              description = lib.mdDoc ''
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
              description = lib.mdDoc ''
                Username to connect with psycopg2, set to null
                when using sqlite3.
              '';
            };

            url_preview_enabled = mkOption {
              type = types.bool;
              default = true;
              example = false;
              description = lib.mdDoc ''
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
              description = lib.mdDoc ''
                List of IP address CIDR ranges that the URL preview spider is denied
                from accessing.
              '';
            };

            url_preview_ip_range_whitelist = mkOption {
              type = types.listOf types.str;
              default = [];
              description = lib.mdDoc ''
                List of IP address CIDR ranges that the URL preview spider is allowed
                to access even if they are specified in url_preview_ip_range_blacklist.
              '';
            };

            url_preview_url_blacklist = mkOption {
              type = types.listOf types.str;
              default = [];
              description = lib.mdDoc ''
                Optional list of URL matches that the URL preview spider is
                denied from accessing.
              '';
            };

            max_upload_size = mkOption {
              type = types.str;
              default = "50M";
              example = "100M";
              description = lib.mdDoc ''
                The largest allowed upload size in bytes
              '';
            };

            max_image_pixels = mkOption {
              type = types.str;
              default = "32M";
              example = "64M";
              description = lib.mdDoc ''
                Maximum number of pixels that will be thumbnailed
              '';
            };

            dynamic_thumbnails = mkOption {
              type = types.bool;
              default = false;
              example = true;
              description = lib.mdDoc ''
                Whether to generate new thumbnails on the fly to precisely match
                the resolution requested by the client. If true then whenever
                a new resolution is requested by the client the server will
                generate a new thumbnail. If false the server will pick a thumbnail
                from a precalculated list.
              '';
            };

            turn_uris = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [
                "turn:turn.example.com:3487?transport=udp"
                "turn:turn.example.com:3487?transport=tcp"
                "turns:turn.example.com:5349?transport=udp"
                "turns:turn.example.com:5349?transport=tcp"
              ];
              description = lib.mdDoc ''
                The public URIs of the TURN server to give to clients
              '';
            };
            turn_shared_secret = mkOption {
              type = types.str;
              default = "";
              example = literalExpression ''
                config.services.coturn.static-auth-secret
              '';
              description = mdDoc ''
                The shared secret used to compute passwords for the TURN server.

                Secrets should be passed in via `extraConfigFiles`!
              '';
            };

            trusted_key_servers = mkOption {
              type = types.listOf (types.submodule {
                options = {
                  server_name = mkOption {
                    type = types.str;
                    example = "matrix.org";
                    description = lib.mdDoc ''
                      Hostname of the trusted server.
                    '';
                  };

                  verify_keys = mkOption {
                    type = types.nullOr (types.attrsOf types.str);
                    default = null;
                    example = literalExpression ''
                      {
                        "ed25519:auto" = "Noi6WqcDj0QmPxCNQqgezwTlBKrfqehY1u2FyWP9uYw";
                      }
                    '';
                    description = lib.mdDoc ''
                      Attribute set from key id to base64 encoded public key.

                      If specified synapse will check that the response is signed
                      by at least one of the given keys.
                    '';
                  };
                };
              });
              default = [ {
                server_name = "matrix.org";
                verify_keys = {
                  "ed25519:auto" = "Noi6WqcDj0QmPxCNQqgezwTlBKrfqehY1u2FyWP9uYw";
                };
              } ];
              description = lib.mdDoc ''
                The trusted servers to download signing keys from.
              '';
            };

            app_service_config_files = mkOption {
              type = types.listOf types.path;
              default = [ ];
              description = lib.mdDoc ''
                A list of application service config file to use
              '';
            };

          };
        };
      };

      extraConfigFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = lib.mdDoc ''
          Extra config files to include.

          The configuration files will be included based on the command line
          argument --config-path. This allows to configure secrets without
          having to go through the Nix store, e.g. based on deployment keys if
          NixOps is in use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = hasLocalPostgresDB -> config.services.postgresql.enable;
        message = ''
          Cannot deploy matrix-synapse with a configuration for a local postgresql database
            and a missing postgresql service. Since 20.03 it's mandatory to manually configure the
            database (please read the thread in https://github.com/NixOS/nixpkgs/pull/80447 for
            further reference).

            If you
            - try to deploy a fresh synapse, you need to configure the database yourself. An example
              for this can be found in <nixpkgs/nixos/tests/matrix-synapse.nix>
            - update your existing matrix-synapse instance, you simply need to add `services.postgresql.enable = true`
              to your configuration.

          For further information about this update, please read the release-notes of 20.03 carefully.
        '';
      }
    ];

    services.matrix-synapse.configFile = configFile;

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

    systemd.services.matrix-synapse = {
      description = "Synapse Matrix homeserver";
      after = [ "network.target" ] ++ optional hasLocalPostgresDB "postgresql.service";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        ${cfg.package}/bin/synapse_homeserver \
          --config-path ${configFile} \
          --keys-directory ${cfg.dataDir} \
          --generate-keys
      '';
      environment = {
        PYTHONPATH = makeSearchPathOutput "lib" cfg.package.python.sitePackages [ pluginsEnv ];
      } // optionalAttrs (cfg.withJemalloc) {
        LD_PRELOAD = "${pkgs.jemalloc}/lib/libjemalloc.so";
      };
      serviceConfig = {
        Type = "notify";
        User = "matrix-synapse";
        Group = "matrix-synapse";
        WorkingDirectory = cfg.dataDir;
        ExecStartPre = [ ("+" + (pkgs.writeShellScript "matrix-synapse-fix-permissions" ''
          chown matrix-synapse:matrix-synapse ${cfg.dataDir}/homeserver.signing.key
          chmod 0600 ${cfg.dataDir}/homeserver.signing.key
        '')) ];
        ExecStart = ''
          ${cfg.package}/bin/synapse_homeserver \
            ${ concatMapStringsSep "\n  " (x: "--config-path ${x} \\") ([ configFile ] ++ cfg.extraConfigFiles) }
            --keys-directory ${cfg.dataDir}
        '';
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
        ReadWritePaths = [ cfg.dataDir ];
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" ];
      };
    };

    environment.systemPackages = [ registerNewMatrixUser ];
  };

  meta = {
    buildDocsInSandbox = false;
    doc = ./synapse.xml;
    maintainers = teams.matrix.members;
  };

}
