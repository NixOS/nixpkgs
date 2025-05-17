{
  config,
  lib,
  pkgs,
  options,
  ...
}:
let
  cfg = config.services.taguette;
  opt = options.services.taguette;
  settingsFormat = pkgs.formats.pythonVars { };
in
{
  options = {
    services.taguette = {
      enable = lib.mkEnableOption "the Taguette server";
      package = lib.mkPackageOption pkgs "taguette" { };

      settings = lib.mkOption {
        description = ''
          Configuration options.
        '';

        defaultText = ''
          NAME = "NixOS Taguette Server";
        '';

        default = {
          NAME = lib.mkDefault "NixOS Taguette Server";
          BIND_ADDRESS = lib.mkDefault cfg.host;
          PORT = lib.mkDefault cfg.port;
          BASE_PATH = lib.mkDefault "";
          SECRET_KEY = lib.mkDefault (
            if cfg.secretKeyFile != null then
              ''
                $(cat ${cfg.secretKeyFile})
              ''
            else
              "{secret}"
          );
          DATABASE = lib.mkDefault cfg.databaseURL;
          EMAIL = lib.mkDefault "NixOS Taguette Server <taguette@example.com>";
          DEFAULT_LANGUAGE = lib.mkDefault "en_US";
          COOKIES_PROMPT = lib.mkDefault false;
          REGISTRATION_ENABLED = lib.mkDefault true;
          SQLITE3_IMPORT_ENABLED = lib.mkDefault true;
          X_HEADERS = lib.mkDefault false;
          CONVERT_TO_HTML_TIMEOUT = lib.mkDefault 180;
          CONVERT_FROM_HTML_TIMEOUT = lib.mkDefault 180;
          TOS_FILE = lib.mkDefault null;
          MAIL_SERVER = lib.mkDefault {
            ssl = false;
            host = "localhost";
            port = 25;
          };
          EXTRA_FOOTER = lib.mkDefault null;
          MULTIUSER = lib.mkDefault true;
        };

        type = lib.types.submodule {
          freeformType = settingsFormat.type;
        };
      };

      stateDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/taguette";
        example = "/home/foo";
        description = "State directory of Taguette.";
      };

      adminPasswordFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          Password for the admin account.
          NOTE: Should be string not a store path, to prevent the file from being world readable
        '';
      };

      secretKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to a file containing the secret key that will be used to sign cookies.
          NOTE: Should be string not a store path, to prevent the file from being world readable
        '';
      };

      host = lib.mkOption {
        default = "127.0.0.1";
        description = ''
          The host name or IP address the server should listen to.
        '';
        type = lib.types.str;
      };

      port = lib.mkOption {
        default = 7465;
        description = ''
          The port the server should listen to.
        '';
        type = lib.types.port;
      };

      databaseURL = lib.mkOption {
        default = "sqlite:////var/lib/taguette/taguette.db";
        description = ''
          The database file to use.
        '';
        type = lib.types.str;
      };

      openFirewall = lib.mkEnableOption "firewall passthrough for Taguette";
    };
  };

  config = lib.mkIf cfg.enable {
    # Override the `settings` with custom config options
    services.taguette.settings = opt.settings.default;

    systemd.services.taguette =
      let
        config = settingsFormat.generate "config" (cfg.settings);
      in
      {
        description = "Taguette server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          WorkingDirectory = cfg.stateDir;
          StateDirectory = "taguette";
          RuntimeDirectory = "taguette";
          Environment = [
            "HOME=%S/taguette"
          ];
          LoadCredential = [
            "admin_password:${cfg.adminPasswordFile}"
          ];
          DynamicUser = true;
          PrivateTmp = "yes";
          Restart = "on-failure";
        };

        script = ''
          PW_FILE="$CREDENTIALS_DIRECTORY/admin_password"
          (
            PW=$(cat "$PW_FILE")
            echo "$PW"
          ) | exec ${lib.getExe cfg.package} --no-browser server ${config}
        '';
      };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };

  meta = {
    maintainers = with lib.maintainers; [ drupol ];
  };
}
