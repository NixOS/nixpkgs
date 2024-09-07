{ config, lib, pkgs, ... }:
let
  cfg = config.services.gotosocial;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yml" cfg.settings;
  defaultSettings = {
    application-name = "gotosocial";

    protocol = "https";

    bind-address = "127.0.0.1";
    port = 8080;

    storage-local-base-path = "/var/lib/gotosocial/storage";

    db-type = "sqlite";
    db-address = "/var/lib/gotosocial/database.sqlite";
  };
  gotosocial-admin = pkgs.writeShellScriptBin "gotosocial-admin" ''
    exec systemd-run \
      -u gotosocial-admin.service \
      -p Group=gotosocial \
      -p User=gotosocial \
      -q -t -G --wait --service-type=exec \
      ${cfg.package}/bin/gotosocial --config-path ${configFile} admin "$@"
  '';
in
{
  meta.doc = ./gotosocial.md;
  meta.maintainers = with lib.maintainers; [ blakesmith ];

  options.services.gotosocial = {
    enable = lib.mkEnableOption "ActivityPub social network server";

    package = lib.mkPackageOption pkgs "gotosocial" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open the configured port in the firewall.
        Using a reverse proxy instead is highly recommended.
      '';
    };

    setupPostgresqlDB = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to setup a local postgres database and populate the
        `db-type` fields in `services.gotosocial.settings`.
      '';
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = defaultSettings;
      example = {
        application-name = "My GoToSocial";
        host = "gotosocial.example.com";
      };
      description = ''
        Contents of the GoToSocial YAML config.

        Please refer to the
        [documentation](https://docs.gotosocial.org/en/latest/configuration/)
        and
        [example config](https://github.com/superseriousbusiness/gotosocial/blob/main/example/config.yaml).

        Please note that the `host` option cannot be changed later so it is important to configure this correctly before you start GoToSocial.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''
        File path containing environment variables for configuring the GoToSocial service
        in the format of an EnvironmentFile as described by systemd.exec(5).

        This option could be used to pass sensitive configuration to the GoToSocial daemon.

        Please refer to the Environment Variables section in the
        [documentation](https://docs.gotosocial.org/en/latest/configuration/).
      '';
      default = null;
      example = "/root/nixos/secrets/gotosocial.env";
    };

  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.host or null != null;
        message = ''
          You have to define a hostname for GoToSocial (`services.gotosocial.settings.host`), it cannot be changed later without starting over!
        '';
      }
    ];

    services.gotosocial.settings = (lib.mapAttrs (name: lib.mkDefault) (
      defaultSettings // {
        web-asset-base-dir = "${cfg.package}/share/gotosocial/web/assets/";
        web-template-base-dir = "${cfg.package}/share/gotosocial/web/template/";
      }
    )) // (lib.optionalAttrs cfg.setupPostgresqlDB {
      db-type = "postgres";
      db-address = "/run/postgresql";
      db-database = "gotosocial";
      db-user = "gotosocial";
    });

    environment.systemPackages = [ gotosocial-admin ];

    users.groups.gotosocial = { };
    users.users.gotosocial = {
      group = "gotosocial";
      isSystemUser = true;
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.port ];
    };

    services.postgresql = lib.mkIf cfg.setupPostgresqlDB {
      enable = true;
      ensureDatabases = [ "gotosocial" ];
      ensureUsers = [
        {
          name = "gotosocial";
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services.gotosocial = {
      description = "ActivityPub social network server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ]
        ++ lib.optional cfg.setupPostgresqlDB "postgresql.service";
      requires = lib.optional cfg.setupPostgresqlDB "postgresql.service";
      restartTriggers = [ configFile ];

      serviceConfig = {
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = "${cfg.package}/bin/gotosocial --config-path ${configFile} server start";
        Restart = "on-failure";
        Group = "gotosocial";
        User = "gotosocial";
        StateDirectory = "gotosocial";
        WorkingDirectory = "/var/lib/gotosocial";

        # Security options:
        # Based on https://github.com/superseriousbusiness/gotosocial/blob/v0.8.1/example/gotosocial.service
        AmbientCapabilities = lib.optional (cfg.settings.port < 1024) "CAP_NET_BIND_SERVICE";
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        DevicePolicy = "closed";
        ProtectSystem = "full";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        LockPersonality = true;
      };
    };
  };
}
