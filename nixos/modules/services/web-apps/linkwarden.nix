{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.linkwarden;
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    literalExpression
    mkForce
    mkMerge
    optional
    optionals
    optionalAttrs
    ;
  database_information = {
    DATABASE_URL = "postgres://linkwarden@localhost/linkwarden?host=/run/postgresql";
  };

  linkwarden = cfg.package.withUserConfiguration {
    secret = cfg.secret;
    # secretFile = cfg.secretFile;
    authUrl = "https://${cfg.domain}/api/v1/auth";
    databaseURI = database_information.DATABASE_URL;
    dataStoragePath = cfg.data_path;
  };
in
{
  options.services.linkwarden = {
    enable = mkEnableOption "linkwarden";
    package = mkOption {
      type = types.package;
      default = pkgs.linkwarden;
      defaultText = "pkgs.linkwarden";
      description = "The linkwarden package to use.";
    };
    domain = mkOption {
      type = types.str;
      description = "FQDN for linkwarden";
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
        description = "Create the database and database user locally.";
      };
    };
    secret = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Secret used by linkwarden";
    };
    secretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to file containing secret";
    };
    settings = mkOption {
      type = types.attrs;
      default = { };
      description = "Environment variables to pass to linkwarden. See [documentation](https://docs.linkwarden.app/self-hosting/environment-variables)";
    };
    settingsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/linkwarden.env";
      description = ''
        Environment variables to pass to linkwarden. Use this to pass secrets and other sensitive data. See [documentation](https://docs.linkwarden.app/self-hosting/environment-variables)
      '';
    };
    data_path = mkOption {
      type = types.str;
      default = "/var/lib/linkwarden/data";
      description = "Path to store the application data";
    };
    nginx = mkOption {
      type = types.nullOr (
        types.submodule (import ../web-servers/nginx/vhost-options.nix { inherit config lib; })
      );
      default = null;
      example = literalExpression ''
        {
          serverAliases = [
            "linkwarden.''${config.networking.domain}"
          ];
          enableACME = true;
          forceHttps = true;
        }
      '';
      description = ''
        With this option, you can customize an nginx virtual host which already has sensible defaults for linkwarden.
        Set to {} if you do not need any customization to the virtual host.
        If enabled, then by default, the {option}`serverName` is
        `''${host}`,
        If this is set to null (the default), no nginx virtualHost will be configured.
      '';
    };

  };
  config = mkIf cfg.enable {
    systemd.services.linkwarden = {
      wantedBy = [ "multi-user.target" ];
      wants = optionals cfg.database.createLocally [ "postgresql.service" ];
      after = optionals cfg.database.createLocally [ "postgresql.service" ];
      path = [
        pkgs.nodejs
        pkgs.concurrently
        pkgs.nodePackages.ts-node
        pkgs.nodePackages.prisma
        pkgs.prisma-engines
        pkgs.openssl
        pkgs.playwright
        pkgs.playwright-driver
        pkgs.monolith
      ] ++ cfg.package.workspaceDependencies;
      environment = {
        HOME = "/var/lib/linkwarden";
        PORT = builtins.toString cfg.port;
        HOST = cfg.host;
        STORAGE_FOLDER = "data";
        PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
        PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
        PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
        PRISMA_INTROSPECTION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/introspection-engine";
        PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
        PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING = "1";
        PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
        PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
        PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
        PLAYWRIGHT_NODEJS_PATH = "${pkgs.nodejs}/bin/node";
        NIXPKGS_PLAYRIGHT_EXECUTABLE_PATH = "${pkgs.playwright-driver.browsers}/chromium-1091/chrome-linux/chrome";
      } // cfg.settings // optionalAttrs cfg.database.createLocally database_information;

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "linkwarden";
        WorkingDirectory = "/var/lib/linkwarden";
        PrivateTmp = true;
        ExecStartPre = linkwarden.preStartScript;
        ExecStart = linkwarden.startScript;
      } // optionalAttrs (cfg.settingsFile != null) { EnvironmentFile = cfg.settingsFile; };
    };
    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ "linkwarden" ];
      ensureUsers = [
        {
          name = "linkwarden";
          ensureDBOwnership = true;
        }
      ];
    };
    services.nginx = mkIf (cfg.nginx != null) {
      enable = true;
      virtualHosts."${cfg.domain}" = mkMerge [
        cfg.nginx
        { root = mkForce linkwarden.rootFolder; }
      ];
    };
  };
}
