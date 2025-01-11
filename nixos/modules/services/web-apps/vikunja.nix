{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.services.vikunja;
  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yaml" cfg.settings;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "vikunja" "setupNginx" ]
      "services.vikunja no longer supports the automatic set up of a nginx virtual host. Set up your own webserver config with a proxy pass to the vikunja service."
    )
  ];

  options.services.vikunja = with lib; {
    enable = mkEnableOption "vikunja service";
    package = mkPackageOption pkgs "vikunja" { };
    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        List of environment files set in the vikunja systemd service.
        For example passwords should be set in one of these files.
      '';
    };
    frontendScheme = mkOption {
      type = types.enum [
        "http"
        "https"
      ];
      description = ''
        Whether the site is available via http or https.
      '';
    };
    frontendHostname = mkOption {
      type = types.str;
      description = "The Hostname under which the frontend is running.";
    };
    port = mkOption {
      type = types.port;
      default = 3456;
      description = "The TCP port exposed by the API.";
    };

    settings = mkOption {
      type = format.type;
      default = { };
      description = ''
        Vikunja configuration. Refer to
        <https://vikunja.io/docs/config-options/>
        for details on supported values.
      '';
    };
    database = {
      type = mkOption {
        type = types.enum [
          "sqlite"
          "mysql"
          "postgres"
        ];
        example = "postgres";
        default = "sqlite";
        description = "Database engine to use.";
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "Database host address. Can also be a socket.";
      };
      user = mkOption {
        type = types.str;
        default = "vikunja";
        description = "Database user.";
      };
      database = mkOption {
        type = types.str;
        default = "vikunja";
        description = "Database name.";
      };
      path = mkOption {
        type = types.str;
        default = "/var/lib/vikunja/vikunja.db";
        description = "Path to the sqlite3 database file.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.vikunja.settings = {
      database = {
        inherit (cfg.database)
          type
          host
          user
          database
          path
          ;
      };
      service = {
        interface = ":${toString cfg.port}";
        frontendurl = "${cfg.frontendScheme}://${cfg.frontendHostname}/";
      };
      files = {
        basepath = "/var/lib/vikunja/files";
      };
    };

    systemd.services.vikunja = {
      description = "vikunja";
      after =
        [ "network.target" ]
        ++ lib.optional usePostgresql "postgresql.service"
        ++ lib.optional useMysql "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];
      restartTriggers = [ configFile ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "vikunja";
        ExecStart = "${cfg.package}/bin/vikunja";
        Restart = "always";
        EnvironmentFile = cfg.environmentFiles;
      };
    };

    environment.etc."vikunja/config.yaml".source = configFile;

    environment.systemPackages = [
      cfg.package # for admin `vikunja` CLI
    ];
  };
}
