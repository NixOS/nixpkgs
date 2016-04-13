{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.matrix-synapse;
  logConfigFile = pkgs.writeText "log_config.yaml" cfg.logConfig;
  configFile = pkgs.writeText "homeserver.yaml" ''
tls_certificate_path: "${cfg.tls_certificate_path}"
tls_private_key_path: "${cfg.tls_private_key_path}"
tls_dh_params_path: "${cfg.tls_dh_params_path}"
no_tls: ${if cfg.no_tls then "true" else "false"}
bind_port: ${toString cfg.bind_port}
unsecure_port: ${toString cfg.unsecure_port}
bind_host: "${cfg.bind_host}"
server_name: "${cfg.server_name}"
pid_file: "/var/run/matrix-synapse.pid"
web_client: ${if cfg.web_client then "true" else "false"}
database: {
  name: "${cfg.database_type}",
  args: {
    ${concatStringsSep ",\n    " (
      mapAttrsToList (n: v: "\"${n}\": ${v}") cfg.database_args
    )}
  }
}
log_file: "/var/log/matrix-synapse/homeserver.log"
log_config: "${logConfigFile}"
media_store_path: "/var/lib/matrix-synapse/media"
recaptcha_private_key: "${cfg.recaptcha_private_key}"
recaptcha_public_key: "${cfg.recaptcha_public_key}"
enable_registration_captcha: ${if cfg.enable_registration_captcha then "true" else "false"}
turn_uris: ${if (length cfg.turn_uris) == 0 then "[]" else ("\n" + (concatStringsSep "\n" (map (s: "- " + s) cfg.turn_uris)))}
turn_shared_secret: "${cfg.turn_shared_secret}"
enable_registration: ${if cfg.enable_registration then "true" else "false"}
${optionalString (cfg.registration_shared_secret != "") ''
registration_shared_secret: "${cfg.registration_shared_secret}"
''}
enable_metrics: ${if cfg.enable_metrics then "true" else "false"}
report_stats: ${if cfg.report_stats then "true" else "false"}
signing_key_path: "/var/lib/matrix-synapse/homeserver.signing.key"
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
${cfg.extraConfig}
'';
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
      no_tls = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Don't bind to the https port
        '';
      };
      tls_certificate_path = mkOption {
        type = types.path;
        default = "/var/lib/matrix-synapse/homeserver.tls.crt";
        description = ''
          PEM encoded X509 certificate for TLS
        '';
      };
      tls_private_key_path = mkOption {
        type = types.path;
        default = "/var/lib/matrix-synapse/homeserver.tls.key";
        description = ''
          PEM encoded private key for TLS
        '';
      };
      tls_dh_params_path = mkOption {
        type = types.path;
        default = "/var/lib/matrix-synapse/homeserver.tls.dh";
        description = ''
          PEM dh parameters for ephemeral keys
        '';
      };
      bind_port = mkOption {
        type = types.int;
        default = 8448;
        description = ''
          The port to listen for HTTPS requests on.
          For when matrix traffic is sent directly to synapse.
        '';
      };
      unsecure_port = mkOption {
        type = types.int;
        default = 8008;
        description = ''
          The port to listen for HTTP requests on.
          For when matrix traffic passes through loadbalancer that unwraps TLS.
        '';
      };
      bind_host = mkOption {
        type = types.str;
        default = "";
        description = ''
          Local interface to listen on.
          The empty string will cause synapse to listen on all interfaces.
        '';
      };
      server_name = mkOption {
        type = types.str;
        description = ''
          The domain name of the server, with optional explicit port.
          This is used by remote servers to connect to this server,
          e.g. matrix.org, localhost:8080, etc.
          This is also the last part of your UserID.
        '';
      };
      web_client = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to serve a web client from the HTTP/HTTPS root resource.
        '';
      };
      database_type = mkOption {
        type = types.enum [ "sqlite3" "psycopg2" ];
        default = "sqlite3";
        description = ''
          The database engine name. Can be sqlite or psycopg2.
        '';
      };
      database_args = mkOption {
        type = types.attrs;
        default = {
          database = "/var/lib/matrix-synapse/homeserver.db";
        };
        description = ''
          Arguments to pass to the engine.
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
      enable_registration = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable registration for new users.
        '';
      };
      registration_shared_secret = mkOption {
        type = types.str;
        default = "";
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
        type = types.attrs;
        default = {
          "matrix.org" = {
            "ed25519:auto" = "Noi6WqcDj0QmPxCNQqgezwTlBKrfqehY1u2FyWP9uYw";
          };
        };
        description = ''
          The trusted servers to download signing keys from.
        '';
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra config options for matrix-synapse.
        '';
      };
      logConfig = mkOption {
        type = types.lines;
        default = readFile ./matrix-synapse-log_config.yaml;
        description = ''
          A yaml python logging config file
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers = [
      { name = "matrix-synapse";
        group = "matrix-synapse";
        home = "/var/lib/matrix-synapse";
        createHome = true;
        shell = "${pkgs.bash}/bin/bash";
        uid = config.ids.uids.matrix-synapse;
      } ];

    users.extraGroups = [
      { name = "matrix-synapse";
        gid = config.ids.gids.matrix-synapse;
      } ];

    systemd.services.matrix-synapse = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p /var/lib/matrix-synapse
        chmod 700 /var/lib/matrix-synapse
        chown -R matrix-synapse:matrix-synapse /var/lib/matrix-synapse
        ${cfg.package}/bin/homeserver --config-path ${configFile} --generate-keys
      '';
      serviceConfig = {
        Type = "simple";
        User = "matrix-synapse";
        Group = "matrix-synapse";
        WorkingDirectory = "/var/lib/matrix-synapse";
        PermissionsStartOnly = true;
        ExecStart = "${cfg.package}/bin/homeserver --config-path ${configFile}";
      };
    };
  };
}
