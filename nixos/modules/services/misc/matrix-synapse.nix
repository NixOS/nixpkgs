{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.matrix-synapse;
  pg = config.services.postgresql;
  usePostgresql = cfg.database_type == "psycopg2";
  logConfigFile = pkgs.writeText "log_config.yaml" cfg.logConfig;
  mkResource = r: ''{names: ${builtins.toJSON r.names}, compress: ${boolToString r.compress}}'';
  mkListener = l: ''{port: ${toString l.port}, bind_address: "${l.bind_address}", type: ${l.type}, tls: ${boolToString l.tls}, x_forwarded: ${boolToString l.x_forwarded}, resources: [${concatStringsSep "," (map mkResource l.resources)}]}'';
  pluginsEnv = cfg.package.python.buildEnv.override {
    extraLibs = cfg.plugins;
  };
  configFile = pkgs.writeText "homeserver.yaml" ''
${optionalString (cfg.tls_certificate_path != null) ''
tls_certificate_path: "${cfg.tls_certificate_path}"
''}
${optionalString (cfg.tls_private_key_path != null) ''
tls_private_key_path: "${cfg.tls_private_key_path}"
''}
${optionalString (cfg.tls_dh_params_path != null) ''
tls_dh_params_path: "${cfg.tls_dh_params_path}"
''}
no_tls: ${boolToString cfg.no_tls}
${optionalString (cfg.bind_port != null) ''
bind_port: ${toString cfg.bind_port}
''}
${optionalString (cfg.unsecure_port != null) ''
unsecure_port: ${toString cfg.unsecure_port}
''}
${optionalString (cfg.bind_host != null) ''
bind_host: "${cfg.bind_host}"
''}
server_name: "${cfg.server_name}"
pid_file: "/run/matrix-synapse.pid"
${optionalString (cfg.public_baseurl != null) ''
public_baseurl: "${cfg.public_baseurl}"
''}
listeners: [${concatStringsSep "," (map mkListener cfg.listeners)}]
database: {
  name: "${cfg.database_type}",
  args: {
    ${concatStringsSep ",\n    " (
      mapAttrsToList (n: v: "\"${n}\": ${builtins.toJSON v}") cfg.database_args
    )}
  }
}
event_cache_size: "${cfg.event_cache_size}"
verbose: ${cfg.verbose}
log_config: "${logConfigFile}"
rc_messages_per_second: ${cfg.rc_messages_per_second}
rc_message_burst_count: ${cfg.rc_message_burst_count}
federation_rc_window_size: ${cfg.federation_rc_window_size}
federation_rc_sleep_limit: ${cfg.federation_rc_sleep_limit}
federation_rc_sleep_delay: ${cfg.federation_rc_sleep_delay}
federation_rc_reject_limit: ${cfg.federation_rc_reject_limit}
federation_rc_concurrent: ${cfg.federation_rc_concurrent}
media_store_path: "${cfg.dataDir}/media"
uploads_path: "${cfg.dataDir}/uploads"
max_upload_size: "${cfg.max_upload_size}"
max_image_pixels: "${cfg.max_image_pixels}"
dynamic_thumbnails: ${boolToString cfg.dynamic_thumbnails}
url_preview_enabled: ${boolToString cfg.url_preview_enabled}
${optionalString (cfg.url_preview_enabled == true) ''
url_preview_ip_range_blacklist: ${builtins.toJSON cfg.url_preview_ip_range_blacklist}
url_preview_ip_range_whitelist: ${builtins.toJSON cfg.url_preview_ip_range_whitelist}
url_preview_url_blacklist: ${builtins.toJSON cfg.url_preview_url_blacklist}
''}
recaptcha_private_key: "${cfg.recaptcha_private_key}"
recaptcha_public_key: "${cfg.recaptcha_public_key}"
enable_registration_captcha: ${boolToString cfg.enable_registration_captcha}
turn_uris: ${builtins.toJSON cfg.turn_uris}
turn_shared_secret: "${cfg.turn_shared_secret}"
enable_registration: ${boolToString cfg.enable_registration}
${optionalString (cfg.registration_shared_secret != null) ''
registration_shared_secret: "${cfg.registration_shared_secret}"
''}
recaptcha_siteverify_api: "https://www.google.com/recaptcha/api/siteverify"
turn_user_lifetime: "${cfg.turn_user_lifetime}"
user_creation_max_duration: ${cfg.user_creation_max_duration}
bcrypt_rounds: ${cfg.bcrypt_rounds}
allow_guest_access: ${boolToString cfg.allow_guest_access}

account_threepid_delegates:
  ${optionalString (cfg.account_threepid_delegates.email != null) "email: ${cfg.account_threepid_delegates.email}"}
  ${optionalString (cfg.account_threepid_delegates.msisdn != null) "msisdn: ${cfg.account_threepid_delegates.msisdn}"}

room_invite_state_types: ${builtins.toJSON cfg.room_invite_state_types}
${optionalString (cfg.macaroon_secret_key != null) ''
  macaroon_secret_key: "${cfg.macaroon_secret_key}"
''}
expire_access_token: ${boolToString cfg.expire_access_token}
enable_metrics: ${boolToString cfg.enable_metrics}
report_stats: ${boolToString cfg.report_stats}
signing_key_path: "${cfg.dataDir}/homeserver.signing.key"
key_refresh_interval: "${cfg.key_refresh_interval}"
perspectives:
  servers: {
    ${concatStringsSep "},\n" (mapAttrsToList (n: v: ''
    "${n}": {
      "verify_keys": {
        ${concatStringsSep "},\n" (mapAttrsToList (n: v: ''
        "${n}": {
          "key": "${v}"
        }'') v)}
      }
    '') cfg.servers)}
    }
  }
redaction_retention_period: ${toString cfg.redaction_retention_period}
app_service_config_files: ${builtins.toJSON cfg.app_service_config_files}

${cfg.extraConfig}
'';

  hasLocalPostgresDB = let args = cfg.database_args; in
    usePostgresql && (!(args ? host) || (elem args.host [ "localhost" "127.0.0.1" "::1" ]));
in {
  options = {
    services.matrix-synapse = {
      enable = mkEnableOption "matrix.org synapse";
      package = mkOption {
        type = types.package;
        default = pkgs.matrix-synapse;
        defaultText = "pkgs.matrix-synapse";
        description = ''
          Overridable attribute of the matrix synapse server package to use.
        '';
      };
      plugins = mkOption {
        type = types.listOf types.package;
        default = [ ];
        defaultText = "with config.services.matrix-synapse.package.plugins [ matrix-synapse-ldap3 matrix-synapse-pam ]";
        description = ''
          List of additional Matrix plugins to make available.
        '';
      };
      no_tls = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Don't bind to the https port
        '';
      };
      bind_port = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 8448;
        description = ''
          DEPRECATED: Use listeners instead.
          The port to listen for HTTPS requests on.
          For when matrix traffic is sent directly to synapse.
        '';
      };
      unsecure_port = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 8008;
        description = ''
          DEPRECATED: Use listeners instead.
          The port to listen for HTTP requests on.
          For when matrix traffic passes through loadbalancer that unwraps TLS.
        '';
      };
      bind_host = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          DEPRECATED: Use listeners instead.
          Local interface to listen on.
          The empty string will cause synapse to listen on all interfaces.
        '';
      };
      tls_certificate_path = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "${cfg.dataDir}/homeserver.tls.crt";
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
        example = "${cfg.dataDir}/homeserver.tls.key";
        description = ''
          PEM encoded private key for TLS. Specify null if synapse is not
          speaking TLS directly.
        '';
      };
      tls_dh_params_path = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "${cfg.dataDir}/homeserver.tls.dh";
        description = ''
          PEM dh parameters for ephemeral keys
        '';
      };
      server_name = mkOption {
        type = types.str;
        example = "example.com";
        default = config.networking.hostName;
        description = ''
          The domain name of the server, with optional explicit port.
          This is used by remote servers to connect to this server,
          e.g. matrix.org, localhost:8080, etc.
          This is also the last part of your UserID.
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
      listeners = mkOption {
        type = types.listOf (types.submodule {
          options = {
            port = mkOption {
              type = types.int;
              example = 8448;
              description = ''
                The port to listen for HTTP(S) requests on.
              '';
            };
            bind_address = mkOption {
              type = types.str;
              default = "";
              example = "203.0.113.42";
              description = ''
                Local interface to listen on.
                The empty string will cause synapse to listen on all interfaces.
              '';
            };
            type = mkOption {
              type = types.str;
              default = "http";
              description = ''
                Type of listener.
              '';
            };
            tls = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether to listen for HTTPS connections rather than HTTP.
              '';
            };
            x_forwarded = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Use the X-Forwarded-For (XFF) header as the client IP and not the
                actual client IP.
              '';
            };
            resources = mkOption {
              type = types.listOf (types.submodule {
                options = {
                  names = mkOption {
                    type = types.listOf types.str;
                    description = ''
                      List of resources to host on this listener.
                    '';
                    example = ["client" "webclient" "federation"];
                  };
                  compress = mkOption {
                    type = types.bool;
                    description = ''
                      Should synapse compress HTTP responses to clients that support it?
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
        default = [{
          port = 8448;
          bind_address = "";
          type = "http";
          tls = true;
          x_forwarded = false;
          resources = [
            { names = ["client" "webclient"]; compress = true; }
            { names = ["federation"]; compress = false; }
          ];
        }];
        description = ''
          List of ports that Synapse should listen on, their purpose and their configuration.
        '';
      };
      verbose = mkOption {
        type = types.str;
        default = "0";
        description = "Logging verbosity level.";
      };
      rc_messages_per_second = mkOption {
        type = types.str;
        default = "0.2";
        description = "Number of messages a client can send per second";
      };
      rc_message_burst_count = mkOption {
        type = types.str;
        default = "10.0";
        description = "Number of message a client can send before being throttled";
      };
      federation_rc_window_size = mkOption {
        type = types.str;
        default = "1000";
        description = "The federation window size in milliseconds";
      };
      federation_rc_sleep_limit = mkOption {
        type = types.str;
        default = "10";
        description = ''
          The number of federation requests from a single server in a window
          before the server will delay processing the request.
        '';
      };
      federation_rc_sleep_delay = mkOption {
        type = types.str;
        default = "500";
        description = ''
          The duration in milliseconds to delay processing events from
          remote servers by if they go over the sleep limit.
        '';
      };
      federation_rc_reject_limit = mkOption {
        type = types.str;
        default = "50";
        description = ''
          The maximum number of concurrent federation requests allowed
          from a single server
        '';
      };
      federation_rc_concurrent = mkOption {
        type = types.str;
        default = "3";
        description = "The number of federation requests to concurrently process from a single server";
      };
      database_type = mkOption {
        type = types.enum [ "sqlite3" "psycopg2" ];
        default = if versionAtLeast config.system.stateVersion "18.03"
          then "psycopg2"
          else "sqlite3";
        description = ''
          The database engine name. Can be sqlite or psycopg2.
        '';
      };
      database_name = mkOption {
        type = types.str;
        default = "matrix-synapse";
        description = "Database name.";
      };
      database_user = mkOption {
        type = types.str;
        default = "matrix-synapse";
        description = "Database user name.";
      };
      database_args = mkOption {
        type = types.attrs;
        default = {
          sqlite3 = { database = "${cfg.dataDir}/homeserver.db"; };
          psycopg2 = {
            user = cfg.database_user;
            database = cfg.database_name;
          };
        }.${cfg.database_type};
        description = ''
          Arguments to pass to the engine.
        '';
      };
      event_cache_size = mkOption {
        type = types.str;
        default = "10K";
        description = "Number of events to cache in memory.";
      };
      url_preview_enabled = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Is the preview URL API enabled?  If enabled, you *must* specify an
          explicit url_preview_ip_range_blacklist of IPs that the spider is
          denied from accessing.
        '';
      };
      url_preview_ip_range_blacklist = mkOption {
        type = types.listOf types.str;
        default = [
          "127.0.0.0/8"
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "100.64.0.0/10"
          "169.254.0.0/16"
          "::1/128"
          "fe80::/64"
          "fc00::/7"
        ];
        description = ''
          List of IP address CIDR ranges that the URL preview spider is denied
          from accessing.
        '';
      };
      url_preview_ip_range_whitelist = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of IP address CIDR ranges that the URL preview spider is allowed
          to access even if they are specified in
          url_preview_ip_range_blacklist.
        '';
      };
      url_preview_url_blacklist = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Optional list of URL matches that the URL preview spider is
          denied from accessing.
        '';
      };
      recaptcha_private_key = mkOption {
        type = types.str;
        default = "";
        description = ''
          This Home Server's ReCAPTCHA private key.
        '';
      };
      recaptcha_public_key = mkOption {
        type = types.str;
        default = "";
        description = ''
          This Home Server's ReCAPTCHA public key.
        '';
      };
      enable_registration_captcha = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables ReCaptcha checks when registering, preventing signup
          unless a captcha is answered. Requires a valid ReCaptcha
          public/private key.
        '';
      };
      turn_uris = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          The public URIs of the TURN server to give to clients
        '';
      };
      turn_shared_secret = mkOption {
        type = types.str;
        default = "";
        description = ''
          The shared secret used to compute passwords for the TURN server
        '';
      };
      turn_user_lifetime = mkOption {
        type = types.str;
        default = "1h";
        description = "How long generated TURN credentials last";
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
        '';
      };
      servers = mkOption {
        type = types.attrsOf (types.attrsOf types.str);
        default = {
          "matrix.org" = {
            "ed25519:auto" = "Noi6WqcDj0QmPxCNQqgezwTlBKrfqehY1u2FyWP9uYw";
          };
        };
        description = ''
          The trusted servers to download signing keys from.
        '';
      };
      max_upload_size = mkOption {
        type = types.str;
        default = "10M";
        description = "The largest allowed upload size in bytes";
      };
      max_image_pixels = mkOption {
        type = types.str;
        default = "32M";
        description = "Maximum number of pixels that will be thumbnailed";
      };
      dynamic_thumbnails = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to generate new thumbnails on the fly to precisely match
          the resolution requested by the client. If true then whenever
          a new resolution is requested by the client the server will
          generate a new thumbnail. If false the server will pick a thumbnail
          from a precalculated list.
        '';
      };
      user_creation_max_duration = mkOption {
        type = types.str;
        default = "1209600000";
        description = ''
          Sets the expiry for the short term user creation in
          milliseconds. The default value is two weeks.
        '';
      };
      bcrypt_rounds = mkOption {
        type = types.str;
        default = "12";
        description = ''
          Set the number of bcrypt rounds used to generate password hash.
          Larger numbers increase the work factor needed to generate the hash.
        '';
      };
      allow_guest_access = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Allows users to register as guests without a password/email/etc, and
          participate in rooms hosted on this server which have been made
          accessible to anonymous users.
        '';
      };
      account_threepid_delegates.email = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Delegate email sending to https://example.org
        '';
      };
      account_threepid_delegates.msisdn = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Delegate SMS sending to this local process (https://localhost:8090)
        '';
      };
      room_invite_state_types = mkOption {
        type = types.listOf types.str;
        default = ["m.room.join_rules" "m.room.canonical_alias" "m.room.avatar" "m.room.name"];
        description = ''
          A list of event types that will be included in the room_invite_state
        '';
      };
      macaroon_secret_key = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Secret key for authentication tokens
        '';
      };
      expire_access_token = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable access token expiration.
        '';
      };
      key_refresh_interval = mkOption {
        type = types.str;
        default = "1d";
        description = ''
          How long key response published by this server is valid for.
          Used to set the valid_until_ts in /key/v2 APIs.
          Determines how quickly servers will query to check which keys
          are still valid.
        '';
      };
      app_service_config_files = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = ''
          A list of application service config file to use
        '';
      };
      redaction_retention_period = mkOption {
        type = types.int;
        default = 7;
        description = ''
          How long to keep redacted events in unredacted form in the database.
        '';
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra config options for matrix-synapse.
        '';
      };
      extraConfigFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
          Extra config files to include.

          The configuration files will be included based on the command line
          argument --config-path. This allows to configure secrets without
          having to go through the Nix store, e.g. based on deployment keys if
          NixOPS is in use.
        '';
      };
      logConfig = mkOption {
        type = types.lines;
        default = readFile ./matrix-synapse-log_config.yaml;
        description = ''
          A yaml python logging config file
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
        ${cfg.package}/bin/homeserver \
          --config-path ${configFile} \
          --keys-directory ${cfg.dataDir} \
          --generate-keys
      '';
      environment.PYTHONPATH = makeSearchPathOutput "lib" cfg.package.python.sitePackages [ pluginsEnv ];
      serviceConfig = {
        Type = "notify";
        User = "matrix-synapse";
        Group = "matrix-synapse";
        WorkingDirectory = cfg.dataDir;
        ExecStart = ''
          ${cfg.package}/bin/homeserver \
            ${ concatMapStringsSep "\n  " (x: "--config-path ${x} \\") ([ configFile ] ++ cfg.extraConfigFiles) }
            --keys-directory ${cfg.dataDir}
        '';
        ExecReload = "${pkgs.utillinux}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
      };
    };
  };

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
  ];

  meta.doc = ./matrix-synapse.xml;
  meta.maintainers = teams.matrix.members;

}
