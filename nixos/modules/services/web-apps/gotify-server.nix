{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.services.gotify;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [
        "services"
        "gotify"
        "port"
      ]
      [
        "services"
        "gotify"
        "environment"
        "GOTIFY_SERVER_PORT"
      ]
    )
  ];

  options.services.gotify = {
    enable = lib.mkEnableOption "Gotify webserver";

    package = lib.mkPackageOption pkgs "gotify-server" { };

    environment = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.int
        ]
      );
      default = { };
      example = {
        GOTIFY_SERVER_PORT = 8080;
        GOTIFY_DATABASE_DIALECT = "sqlite3";
      };
      description = ''
        Config environment variables for the gotify-server.
        See <https://gotify.net/docs/config> for more details.
      '';
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Files containing additional config environment variables for gotify-server.
        Secrets should be set in environmentFiles instead of environment.
      '';
    };

    stateDirectoryName = lib.mkOption {
      type = lib.types.str;
      default = "gotify-server";
      description = ''
        The name of the directory below {file}`/var/lib` where
        gotify stores its runtime data.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.gotify-server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Simple server for sending and receiving messages";

      environment = lib.mapAttrs (_: toString) cfg.environment;

      serviceConfig = {
        WorkingDirectory = "/var/lib/${cfg.stateDirectoryName}";
        StateDirectory = cfg.stateDirectoryName;
        EnvironmentFile = cfg.environmentFiles;
        Restart = "always";
        DynamicUser = true;
        ExecStart = lib.getExe cfg.package;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ DCsunset ];
}
