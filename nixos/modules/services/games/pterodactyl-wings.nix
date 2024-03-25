{ config, pkgs, lib, ... }:
let
  cfg = config.services.pterodactyl-wings;
  settingsFormat = pkgs.formats.yaml {};
in
{
  options.services.pterodactyl-wings = with lib; with lib.types; {
    enable = mkEnableOption "the Pterodactyl wings server manager";

    tokenFile = mkOption {
      type = types.path;
      description = ''
        Path to the panel-generated token for this wings instance.
      '';
    };
    settings = mkOption {
      description = ''
        Configuration options for the wings daemon.
        Some required values must be generated from the controlling panel.
        See [reference](https://github.com/pterodactyl/wings/blob/develop/config/config.go)
        for all options.
      '';
      default = {};
      example = {
        remote = "https://example.com";
        uuid = "e851b74c-2e88-4d5c-8c6e-381218c7119d";
        token_id = "fdZUuYH0k4aa8OGJ";
        api = {
          host = "127.0.0.1";
          port = 6868;
          upload_limit = 1000;
        };
        system = {
          sftp.bind_port = 6869;
          root_directory = "/var/lib/pterodactyl";
          data = "/var/lib/pterodactyl/volumes";
          archive_directory = "/var/lib/pterodactyl/archives";
          backup_directory = "/var/lib/pterodactyl/backups";
        };
       allowed_origins = [ "https://panel.example.com" ];
      };
      type = submodule {
        freeformType = settingsFormat.type;
        options = {
          uuid = mkOption {
            type = str;
            description = ''
              A unique identifier for this node in the Panel.
              Input this from the configuration generated on the panel.
            '';
          };
          token_id = mkOption {
            type = str;
            description = ''
              An identifier for the token which must be included in any requests
              to the panel so that the token can be looked up correctly.
              Input this from the configuration generated on the panel.
            '';
          };
          api = {
            host = mkOption {
              type = str;
              default = "0.0.0.0";
              example = "[::1]";
              description = "The interface that the internal webserver should bind to.";
            };
            port = mkOption {
              type = port;
              default = 8080;
              description = "The port that the internal webserver should bind to.";
            };
            ssl = {
              enabled = mkEnableOption ''
                HTTPS for the API interface.
                Consider using security.acme to create certificates,
                or using a reverse proxy like nginx to secure the connection.
              '';
              cert = mkOption {
                type = nullOr path;
                default = null;
                description = "Path to certificate to use for HTTPS.";
              };
              key = mkOption {
                type = nullOr path;
                default = null;
                description = "Path to key to use for HTTPS.";
              };
            };
          };
          system = {
            root_directory = mkOption {
              type = path;
              default = "/var/lib/pterodactyl";
              description = "Root directory where daemon data is stored.";
            };
            log_directory = mkOption {
              type = path;
              default = "/var/log/pterodactyl";
              description = "Directory where logs for server installations and other wings events are logged.";
            };
            data = mkOption {
              type = path;
              defaultText = "/var/lib/pterodactyl/volumes";
              description = "Directory where game server data is stored.";
            };
            archive_directory = mkOption {
              type = path;
              defaultText = "/var/lib/pterodactyl/archives";
              description = "Directory where server archives for cross-node transferring will be stored.";
            };
            backup_directory = mkOption {
              type = path;
              defaultText = "/var/lib/pterodactyl/backups";
              description = "Directory where local backups will be stored.";
            };
            username = mkOption {
              type = str;
              default = "pterodactyl";
              description = ''
                The user that should own all of the server files, and be used for containers.
                NixOS will create this user and group if left at the default.
              '';
            };
            sftp = {
              bind_address = mkOption {
                type = str;
                default = "0.0.0.0";
                example = "[::1]";
                description = "The bind address of the SFTP server.";
              };
              bind_port = mkOption {
                type = port;
                default = 8080;
                description = "The bind port of the SFTP server.";
              };
              read_only = mkOption {
                type = bool;
                default = false;
                description = "If set to true, no write actions will be allowed on the SFTP server.";
              };
            };
          };
          docker = {
            network = {
              interface = mkOption {
                type = str;
                default = "172.18.0.1";
                description = "The interface that should be used to create the network. Must not conflict with any other interfaces in use by Docker or on the system.";
              };
              dns = mkOption {
                type = listOf str;
                default = [ "1.1.1.1" "1.0.0.1" ];
                description = "The DNS settings for containers.";
              };
            };
          };
          remote = mkOption {
            type = str;
            description = "The URL where the panel is running that this daemon should connect to, to collect data and send events.";
          };
          allowed_origins = mkOption {
            type = listOf str;
            default = [];
            description = "AllowedOrigins is a list of allowed request origins. The Panel URL is automatically allowed, this is only needed for adding additional origins.";
          };
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [ {
      assertion = !cfg.settings.api.ssl.enabled || (cfg.settings.api.ssl.cert != null && cfg.settings.api.ssl.key != null);
      message = "Certificate and key path must be set in config.services.pterodactyl-wings.settings.api.ssl to enable TLS on the API server";
    } ];
    warnings = lib.lists.optional (builtins.hasAttr "token" cfg.settings)
    ''
      A token has been defined at services.wings.settings.token.
      This exposes it in the world-readable nix store, and will be
      overridden by services.wings.tokenFile regardless.
     '';

    virtualisation.docker.enable = true;

    users = lib.optionalAttrs (cfg.settings.system.username == "pterodactyl") {
      users.pterodactyl = {
        isSystemUser = true;
        group = "pterodactyl";
      };
      groups.pterodactyl = {};
    };

    # https://pterodactyl.io/wings/1.0/installing.html#daemonizing-using-systemd
    systemd.services.pterodactyl-wings = let
      cfgFile = settingsFormat.generate "wings.yaml" cfg.settings;
    in {
      requires = [ "docker.service" ];
      after = [ "docker.service" ];
      partOf = [ "docker.service" ];
      description = "Pterodactyl Wings Daemon";
      serviceConfig = {
        WorkingDirectory = "/etc/pterodactyl";
        PIDFile = "/run/wings/daemon.pid";
        RuntimeDirectory = "wings";
        RuntimeDirectoryMode = "0700";
        ExecStartPre = [
          "${pkgs.coreutils}/bin/cp ${cfgFile} \${RUNTIME_DIRECTORY}/wings.yaml"
          "${pkgs.yq-go}/bin/yq -i '.token = (load_str(\"${cfg.tokenFile}\") | trim)' \${RUNTIME_DIRECTORY}/wings.yaml"
        ];
        ExecStart = "${pkgs.pterodactyl-wings}/bin/wings --config \${RUNTIME_DIRECTORY}/wings.yaml";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      startLimitIntervalSec = 30;
      startLimitBurst = 5;
      wantedBy = [ "multi-user.target" ];
    };
  };
}
