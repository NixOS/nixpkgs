{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.hatsu;
in
{
  meta.doc = ./hatsu.md;
  meta.maintainers = with lib.maintainers; [ kwaa ];

  options.services.hatsu = {
    enable = lib.mkEnableOption "Self-hosted and fully-automated ActivityPub bridge for static sites";

    package = lib.mkPackageOption pkgs "hatsu" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (
            nullOr (oneOf [
              bool
              int
              port
              str
            ])
          );

        options = {
          HATSU_DATABASE_URL = lib.mkOption {
            type = lib.types.str;
            default = "sqlite:///var/lib/hatsu/hatsu.sqlite?mode=rwc";
            example = "postgres://username:password@host/database";
            description = "Database URL.";
          };

          HATSU_DOMAIN = lib.mkOption {
            type = lib.types.str;
            description = "The domain name of your instance (eg 'hatsu.local').";
          };

          HATSU_LISTEN_HOST = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Host where hatsu should listen for incoming requests.";
          };

          HATSU_LISTEN_PORT = lib.mkOption {
            type = lib.types.port;
            apply = toString;
            default = 3939;
            description = "Port where hatsu should listen for incoming requests.";
          };

          HATSU_PRIMARY_ACCOUNT = lib.mkOption {
            type = lib.types.str;
            description = "The primary account of your instance (eg 'example.com').";
          };
        };
      };

      default = { };

      description = ''
        Configuration for Hatsu, see
        <link xlink:href="https://hatsu.cli.rs/admins/environments.html"/>
        for supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.hatsu = {
      environment = cfg.settings;

      description = "Hatsu server";
      documentation = [ "https://hatsu.cli.rs/" ];

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "on-failure";
        StateDirectory = "hatsu";
        Type = "simple";
        WorkingDirectory = "%S/hatsu";
      };
    };
  };
}
