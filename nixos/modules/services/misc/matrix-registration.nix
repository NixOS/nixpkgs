{ config, pkgs, lib, ... }:

with lib;
let
  dataDir = "/var/lib/matrix-registration";
  cfg = config.services.matrix-registration;
  format = pkgs.formats.yaml { };

  matrix-registration-config =
    format.generate "config.yaml" cfg.settings;
  matrix-registration-cli-wrapper = pkgs.stdenv.mkDerivation {
    name = "matrix-registration-cli-wrapper";
    buildInputs = [ pkgs.makeWrapper ];
    buildCommand = ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.matrix-registration}/bin/matrix-registration "$out/bin/matrix-registration" \
        --add-flags "--config-path='${matrix-registration-config}'"
    '';
  };
  serviceDependencies = optional config.services.matrix-synapse.enable "matrix-synapse.service";

  synapse_port = (lists.findFirst
    (
      listener: lists.any
        (
          resource: (builtins.elem "client" resource.names)
        )
        listener.resources
    ) 0
    config.services.matrix-synapse.listeners).port;

in
{
  options.services.matrix-registration = {
    enable = mkEnableOption "matrix-registration";

    settings = mkOption {
      default = { };
      description = "matrix-registration configuration.";
      type = types.submodule {
        freeformType = format.type;

        options = {
          server_location = mkOption {
            type = types.str;
            description = ''
              The client base URL.
              It is necessary that `/_synapse/admin/v1/register` is reachable.
              Using a local address is recommended.
            '';
            example = "https://matrix.example.tld";
            default = optionalString (synapse_port > 0)
              "http://localhost:${builtins.toString synapse_port}";
          };
          server_name = mkOption {
            type = types.str;
            description = "The server name of your homeserver.";
            example = "example.tld";
            default = optionalString config.services.matrix-synapse.enable
              config.services.matrix-synapse.server_name;
          };
          registration_shared_secret = mkOption {
            type = types.str;
            default = "";
            description = ''
              The registration secret shared with the synapse configuration.
              This option is discouraged, use the <literal>credentialsFile</literal> option if possible instead.
            '';
            example = "RegistrationSharedSecret";
          };
          admin_api_shared_secret = mkOption {
            type = types.str;
            default = "APIAdminPassword";
            description = ''
              The admin secret to access the API.
              This option is discouraged, use the <literal>credentialsFile</literal> option if possible instead.
            '';
            example = "APIAdminPassword";
          };
          base_url = mkOption {
            type = types.str;
            description = "A prefix for all endpoints.";
            default = "";
          };
          client_redirect = mkOption {
            type = types.str;
            description =
              "The client instance to redirect after succesful registration.";
            default = "https://app.element.io/#/login";
          };
          client_logo = mkOption {
            type = types.path;
            description = "The client logo to display.";
            default =
              "${pkgs.matrix-registration}/lib/python3.8/site-packages/matrix_registration/static/images/element-logo.png";
          };
          db = mkOption {
            type = types.str;
            default = "sqlite:///${dataDir}/db.sqlite3";
            description = "Database URL.";
          };
          host = mkOption {
            type = types.str;
            default = "localhost";
            description = "Which host to listen on.";
          };
          port = mkOption {
            type = types.port;
            default = 5000;
            description = "Which port to listen on.";
          };
          rate_limit = mkOption {
            type = types.listOf types.str;
            default = [ "100 per day" "10 per minute" ];
            description =
              "How often is one IP allowed to access matrix-registration.";
          };
          allow_cors = mkOption {
            type = types.bool;
            default = false;
            description = "Allow Cross Origin Resource Sharing.";
          };
          ip_logging = mkOption {
            type = types.bool;
            default = false;
            description = "Associate IPs to tokens used in the database.";
          };
          logging = mkOption {
            type = types.attrs;
            description = "Python logging configuration.";
            default = {
              disable_existing_loggers = false;
              version = 1;
              root = {
                level = "DEBUG";
                handlers = [ "console" ];
              };
              formatters = {
                brief = { format = "%(name)s - %(levelname)s - %(message)s"; };
              };
              handlers = {
                console = {
                  class = "logging.StreamHandler";
                  level = "INFO";
                  formatter = "brief";
                  stream = "ext://sys.stdout";
                };
              };
            };
          };
          password.min_length = mkOption {
            type = types.ints.positive;
            default = 8;
            description = "Minimum password length for the registered user.";
          };
        };
      };
    };

    credentialsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        File containing variables to be passed to the matrix-registration service,
        in which secret tokens can be specified securely by defining values for:
        <literal>registration_shared_secret</literal>,
        <literal>admin_api_shared_secret</literal>
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.matrix-registration = {
      description =
        "matrix-registration, a token based matrix registration api.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ serviceDependencies;
      after = [ "network-online.target" ] ++ serviceDependencies;

      preStart = ''
        # run automatic database init and migration scripts
        ${pkgs.matrix-registration.alembic}/bin/alembic -x config='${matrix-registration-config}' upgrade head
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        DynamicUser = true;
        PrivateTmp = true;
        WorkingDirectory =
          pkgs.matrix-registration; # necessary for the database migration scripts to be found
        StateDirectory = baseNameOf dataDir;
        UMask = 27;

        LoadCredential = mkIf (cfg.credentialsFile != null) "secrets:${cfg.credentialsFile}";

        ExecStart = ''
          ${pkgs.matrix-registration}/bin/matrix-registration \
            --config-path="${matrix-registration-config}" \
            serve
        '';
      };
    };

    environment.systemPackages = [ matrix-registration-cli-wrapper ];

    assertions = [
      {
        assertion = cfg.settings.server_location != "";
        message = "can't find server location automatically, "
          + "please set `config.services.matrix-registration.settings.server_location`";
      }
    ];
  };

  meta.maintainers = with maintainers; [ zeratax ];
}
