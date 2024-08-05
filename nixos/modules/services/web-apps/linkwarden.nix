{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.linkwarden;
  inherit (lib) mkIf mkOption mkEnableOption types literalExpression optional optionals optionalAttrs;
in {
  options.services.linkwarden = {
    enable = mkEnableOption "linkwarden";
    package = mkOption {
      type = types.package;
      default = pkgs.linkwarden;
      defaultText = "pkgs.linkwarden";
      description = "The linkwarden package to use.";
    };
    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "The interface linkwarden will listen on.";
      example = "0.0.0.0";
    };
    port = mkOption {
      type = types.port;
      default = 3000;
      description = "The port linkwarden will listen on.";
    };

    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Create the database and database user locally.";
      };
    };
    settings = mkOption {
      type = types.attrs;
      default = {};
      description = lib.mdDoc "Environment variables to pass to linkwarden. See [documentation](https://docs.linkwarden.app/self-hosting/environment-variables)";
    };
    settingsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/linkwarden.env";
      description = lib.mdDoc ''
        Environment variables to pass to linkwarden. Use this to pass secrets and other sensitive data. See [documentation](https://docs.linkwarden.app/self-hosting/environment-variables)
      '';
    };
    data_path = mkOption {
      type = types.str;
      default = "/var/lib/linkwarden/data";
      description = "Path to store the application data";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.linkwarden = {
      wantedBy = ["multi-user.target"];
      wants = optionals cfg.database.createLocally ["postgresql.service"];
      path = [pkgs.nodejs pkgs.concurrently pkgs.nodePackages.ts-node pkgs.nodePackages.prisma pkgs.prisma-engines pkgs.openssl] ++ cfg.package.workspaceDependencies;
      environment = let
        database_information = {DATABASE_URL = "postgresql://linkwarden@localhost/linkwarden?host=/run/postgresql";};
      in
        {
          HOME = "/var/lib/linkwarden";
          PORT = builtins.toString cfg.port;
          HOST = cfg.host;
          STORAGE_FOLDER = cfg.data_path;
          PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
          PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
          PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
          PRISMA_INTROSPECTION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/introspection-engine";
          PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
        }
        // cfg.settings
        // optionalAttrs cfg.database.createLocally database_information;

      preStart = ''
        rm -rf /var/lib/private/linkwarden/src/
        cp -r ${cfg.package} /var/lib/private/linkwarden/src
        chmod u+w -R /var/lib/private/linkwarden/src
        cd src
        ${pkgs.yarn}/bin/yarn prisma migrate deploy
      '';
      script = ''
        cd src
        ${pkgs.yarn}/bin/yarn start
      '';
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "linkwarden";
        WorkingDirectory = "/var/lib/linkwarden";
        PrivateTmp = true;
        EnvironmentFile = optional (cfg.settingsFile != null) cfg.settingsFile;
      };
    };
    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = ["linkwrden"];
      ensureUsers = [
        {
          name = "linkwrden";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
