{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.omnom;
  settingsFormat = pkgs.formats.yaml { };

  configFile = settingsFormat.generate "omnom-config.yml" cfg.settings;
in
{
  options = {
    services.omnom = {
      enable = lib.mkEnableOption "Omnom, a webpage bookmarking and snapshotting service";
      package = lib.mkPackageOption pkgs "omnom" { };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/omnom";
        description = "The directory where Omnom stores its data files.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 7331;
        description = "The Omnom service port.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open ports in the firewall.";
      };

      user = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "omnom";
        description = "The Omnom service user.";
      };

      group = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "omnom";
        description = "The Omnom service group.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "File containing the password for the SMTP user.";
      };

      settings = lib.mkOption {
        description = ''
          Configuration options for the /etc/omnom/config.yml file.
        '';
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            app = {
              debug = lib.mkEnableOption "debug mode";
              disable_signup = lib.mkEnableOption "restricting user creation";
              results_per_page = lib.mkOption {
                type = lib.types.int;
                default = 20;
                description = "Number of results per page.";
              };
            };
            db = {
              connection = lib.mkOption {
                type = lib.types.str;
                default = "${cfg.dataDir}/db.sqlite3";
                description = "Database connection URI.";
                defaultText = lib.literalExpression ''
                  "''${config.services.omnom.dataDir}/db.sqlite3"
                '';
              };
              type = lib.mkOption {
                type = lib.types.enum [ "sqlite" ];
                default = "sqlite";
                description = "Database type.";
              };
            };
            server = {
              address = lib.mkOption {
                type = lib.types.str;
                default = "127.0.0.1:${toString cfg.port}";
                description = "Server address.";
                defaultText = lib.literalExpression ''
                  "127.0.0.1:''${config.services.omnom.port}"
                '';
              };
              secure_cookie = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to limit cookies to a secure channel.";
              };
            };
            storage = {
              type = lib.mkOption {
                type = lib.types.str;
                default = "fs";
                description = "Storage type.";
              };
              root = lib.mkOption {
                type = lib.types.path;
                default = "${cfg.dataDir}/static/data";
                defaultText = lib.literalExpression ''
                  "''${config.services.omnom.dataDir}/static/data"
                '';
                description = "Where the snapshots are saved.";
              };
            };
            smtp = {
              tls = lib.mkEnableOption "Whether TLS encryption should be used.";
              tls_allow_insecure = lib.mkEnableOption "Whether to allow insecure TLS.";
              host = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "SMTP server hostname.";
              };
              port = lib.mkOption {
                type = lib.types.port;
                default = 25;
                description = "SMTP server port address.";
              };
              sender = lib.mkOption {
                type = lib.types.str;
                default = "Omnom <omnom@127.0.0.1>";
                description = "Omnom sender e-mail.";
              };
              send_timeout = lib.mkOption {
                type = lib.types.int;
                default = 10;
                description = "Send timeout duration in seconds.";
              };
              connection_timeout = lib.mkOption {
                type = lib.types.int;
                default = 5;
                description = "Connection timeout duration in seconds.";
              };
            };
          };
        };
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !lib.hasAttr "password" cfg.settings.smtp;
        message = ''
          `services.omnom.settings.smtp.password` must be defined in `services.omnom.passwordFile`.
        '';
      }
      {
        assertion = !(cfg.settings.storage.root != "${cfg.dataDir}/static/data");
        message = ''
          For Omnom to access the snapshots, it needs the storage root
          directory to be inside the service's working directory.

          As such, `services.omnom.settings.storage.root` must be the same as
          `''${services.omnom.dataDir}/static/data`.
        '';
      }
    ];

    systemd.services.omnom = {
      path = with pkgs; [
        yq-go # needed by startup script
      ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "omnom";
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
        RestartSec = "10s";
        LoadCredential = lib.optional (cfg.passwordFile != null) "PASSWORD_FILE:${cfg.passwordFile}";
      };
      script = ''
        install -m 600 ${configFile} $STATE_DIRECTORY/config.yml

        ${lib.optionalString (cfg.passwordFile != null) ''
          # merge password into main config
          yq -i '.smtp.password = load(env(CREDENTIALS_DIRECTORY) + "/PASSWORD_FILE")' \
            "$STATE_DIRECTORY/config.yml"
        ''}

        ${lib.getExe cfg.package} listen --config "$STATE_DIRECTORY/config.yml"
      '';
      after = [
        "network.target"
        "systemd-tmpfiles-setup.service"
      ];
      wantedBy = [ "multi-user.target" ];
    };

    # TODO: The program needs to run from the dataDir for it the work, which
    # is difficult to do with a DynamicUser.
    # After this has been fixed upstream, remove this and use DynamicUser, instead.
    # See: https://github.com/asciimoo/omnom/issues/21
    users = {
      users = lib.mkIf (cfg.user == "omnom") {
        omnom = {
          group = cfg.group;
          home = cfg.dataDir;
          isSystemUser = true;
        };
      };
      groups = lib.mkIf (cfg.group == "omnom") { omnom = { }; };
    };

    systemd.tmpfiles.settings."10-omnom" =
      let
        settings = {
          inherit (cfg) user group;
        };
      in
      {
        "${cfg.dataDir}"."d" = settings;
        "${cfg.dataDir}/templates"."L+" = settings // {
          argument = "${cfg.package}/share/templates";
        };
        "${cfg.settings.storage.root}"."d" = settings;
      };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    environment.systemPackages =
      let
        omnom-wrapped = pkgs.writeScriptBin "omnom" ''
          #! ${pkgs.runtimeShell}
          cd ${cfg.dataDir}
          sudo=exec
          if [[ "$USER" != ${cfg.user} ]]; then
            sudo='exec /run/wrappers/bin/sudo -u ${cfg.user}'
          fi
          $sudo ${lib.getExe cfg.package} "$@"
        '';
      in
      [ omnom-wrapped ];
  };
}
