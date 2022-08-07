{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.vikunja;
  format = pkgs.formats.yaml {};
  configFile = format.generate "config.yaml" cfg.settings;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
in {
  options.services.vikunja = with lib; {
    enable = mkEnableOption "vikunja service";
    package-api = mkOption {
      default = pkgs.vikunja-api;
      type = types.package;
      defaultText = literalExpression "pkgs.vikunja-api";
      description = lib.mdDoc "vikunja-api derivation to use.";
    };
    package-frontend = mkOption {
      default = pkgs.vikunja-frontend;
      type = types.package;
      defaultText = literalExpression "pkgs.vikunja-frontend";
      description = lib.mdDoc "vikunja-frontend derivation to use.";
    };
    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = lib.mdDoc ''
        List of environment files set in the vikunja systemd service.
        For example passwords should be set in one of these files.
      '';
    };
    setupNginx = mkOption {
      type = types.bool;
      default = config.services.nginx.enable;
      defaultText = literalExpression "config.services.nginx.enable";
      description = lib.mdDoc ''
        Whether to setup NGINX.
        Further nginx configuration can be done by changing
        {option}`services.nginx.virtualHosts.<frontendHostname>`.
        This does not enable TLS or ACME by default. To enable this, set the
        {option}`services.nginx.virtualHosts.<frontendHostname>.enableACME` to
        `true` and if appropriate do the same for
        {option}`services.nginx.virtualHosts.<frontendHostname>.forceSSL`.
      '';
    };
    frontendScheme = mkOption {
      type = types.enum [ "http" "https" ];
      description = lib.mdDoc ''
        Whether the site is available via http or https.
        This does not configure https or ACME in nginx!
      '';
    };
    frontendHostname = mkOption {
      type = types.str;
      description = lib.mdDoc "The Hostname under which the frontend is running.";
    };

    settings = mkOption {
      type = format.type;
      default = {};
      description = lib.mdDoc ''
        Vikunja configuration. Refer to
        <https://vikunja.io/docs/config-options/>
        for details on supported values.
        '';
    };
    database = {
      type = mkOption {
        type = types.enum [ "sqlite" "mysql" "postgres" ];
        example = "postgres";
        default = "sqlite";
        description = lib.mdDoc "Database engine to use.";
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc "Database host address. Can also be a socket.";
      };
      user = mkOption {
        type = types.str;
        default = "vikunja";
        description = lib.mdDoc "Database user.";
      };
      database = mkOption {
        type = types.str;
        default = "vikunja";
        description = lib.mdDoc "Database name.";
      };
      path = mkOption {
        type = types.str;
        default = "/var/lib/vikunja/vikunja.db";
        description = lib.mdDoc "Path to the sqlite3 database file.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.vikunja.settings = {
      database = {
        inherit (cfg.database) type host user database path;
      };
      service = {
        frontendurl = "${cfg.frontendScheme}://${cfg.frontendHostname}/";
      };
      files = {
        basepath = "/var/lib/vikunja/files";
      };
    };

    systemd.services.vikunja-api = {
      description = "vikunja-api";
      after = [ "network.target" ] ++ lib.optional usePostgresql "postgresql.service" ++ lib.optional useMysql "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package-api ];
      restartTriggers = [ configFile ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "vikunja";
        ExecStart = "${cfg.package-api}/bin/vikunja";
        Restart = "always";
        EnvironmentFile = cfg.environmentFiles;
      };
    };

    services.nginx.virtualHosts."${cfg.frontendHostname}" = mkIf cfg.setupNginx {
      locations = {
        "/" = {
          root = cfg.package-frontend;
          tryFiles = "try_files $uri $uri/ /";
        };
        "~* ^/(api|dav|\\.well-known)/" = {
          proxyPass = "http://localhost:3456";
          extraConfig = ''
            client_max_body_size 20M;
          '';
        };
      };
    };

    environment.etc."vikunja/config.yaml".source = configFile;
  };
}
