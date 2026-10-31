{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.dependency-track;

  settingsFormat = pkgs.formats.javaProperties { };
  frontendSettingsFormat = pkgs.formats.json { };

  # Dependency-Track reads `config/application.properties` relative to its working directory.
  workingDirectory = pkgs.linkFarm "dependency-track-config" {
    "config/application.properties" = settingsFormat.generate "application.properties" cfg.settings;
  };

  frontendConfig = pkgs.runCommand "config.json" { } ''
    ${lib.getExe pkgs.jq} -s '.[0] * .[1]' ${cfg.package.frontend}/static/config.json \
      ${frontendSettingsFormat.generate "settings.json" cfg.frontend.settings} > $out
  '';

  # Otherwise Flyway baselines the v4 schema and partly migrates it.
  checkDatabase = pkgs.writeShellScript "dependency-track-check-database" ''
    set -euo pipefail
    v4=$(${lib.getExe' config.services.postgresql.package "psql"} -d ${
      lib.escapeShellArg cfg.settings."dt.datasource.username"
    } -tAc "SELECT to_regclass('\"SCHEMAVERSION\"') IS NOT NULL")
    if [[ $v4 == t ]]; then
      echo "The database holds Dependency-Track v4 data, which v5 can't use. See the NixOS 26.11 release notes to migrate it." >&2
      exit 1
    fi
  '';

  renamed =
    setting: "Dependency-Track 5 renamed its configuration properties. Set ${setting} instead.";
in
{
  imports =
    lib.mapAttrsToList
      (
        option:
        lib.mkRemovedOptionModule (
          [
            "services"
            "dependency-track"
          ]
          ++ lib.splitString "." option
        )
      )
      (
        {
          logLevel = renamed ''`services.dependency-track.settings."dt.logging.level.\"org.dependencytrack\""`'';
          "database.type" = "Dependency-Track 5 supports only PostgreSQL.";
          "database.databaseName" = renamed ''`services.dependency-track.settings."dt.datasource.url"`'';
          "database.username" = renamed ''`services.dependency-track.settings."dt.datasource.username"`'';
          "database.passwordFile" =
            renamed ''`services.dependency-track.credentials."dt.datasource.password"`'';
          "ldap.bindPasswordFile" =
            renamed ''`services.dependency-track.credentials."dt.ldap.bind-password"`'';
          "frontend.baseUrl" = renamed "`services.dependency-track.frontend.settings.API_BASE_URL`";
        }
        //
          lib.genAttrs
            (map (option: "oidc.${option}") [
              "enable"
              "issuer"
              "clientId"
              "scope"
              "flow"
              "loginButtonText"
              "usernameClaim"
              "userProvisioning"
              "teamSynchronization"
              "teams.claim"
              "teams.default"
            ])
            (
              _:
              renamed "the `dt.oidc.*` properties in `services.dependency-track.settings` and the `OIDC_*` keys in `services.dependency-track.frontend.settings`"
            )
      )
    ++ [
      (lib.mkRenamedOptionModule
        [ "services" "dependency-track" "javaArgs" ]
        [ "services" "dependency-track" "extraArgs" ]
      )
    ];

  options.services.dependency-track = {
    enable = lib.mkEnableOption "Dependency-Track";

    package = lib.mkPackageOption pkgs "dependency-track" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port the API server listens on.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "-Xmx16G" ];
      description = "Extra JVM options.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          "dt.data-directory" = lib.mkOption {
            type = lib.types.externalPath;
            default = "/var/lib/dependency-track";
            description = "Directory where Dependency-Track stores keys and files.";
          };
          "dt.datasource.url" = lib.mkOption {
            type = lib.types.str;
            default = "jdbc:postgresql:${
              cfg.settings."dt.datasource.username"
            }?socketFactory=org.newsclub.net.unix.AFUNIXSocketFactory$FactoryArg&socketFactoryArg=/run/postgresql/.s.PGSQL.5432";
            defaultText = lib.literalExpression ''"jdbc:postgresql:''${config.services.dependency-track.settings."dt.datasource.username"}?socketFactory=org.newsclub.net.unix.AFUNIXSocketFactory$FactoryArg&socketFactoryArg=/run/postgresql/.s.PGSQL.5432"'';
            description = "JDBC URL of the PostgreSQL database.";
          };
          "dt.datasource.username" = lib.mkOption {
            type = lib.types.str;
            default = "dependency-track";
            description = ''
              Database user. With {option}`services.dependency-track.database.createLocally`,
              the local database and the service's system user get the same name.
            '';
          };
        };
      };
      default = { };
      example = {
        "dt.oidc.enabled" = true;
        "dt.oidc.issuer" = "https://auth.example.com";
        "dt.oidc.client-id" = "dependency-track";
        "dt.logging.level.\"org.dependencytrack\"" = "DEBUG";
      };
      description = ''
        Configuration of Dependency-Track. See the
        [configuration reference](https://dependencytrack.github.io/docs/next/reference/configuration/properties/)
        for available properties.
      '';
    };

    credentials = lib.mkOption {
      type = lib.types.attrsOf lib.types.externalPath;
      default = { };
      example = {
        "dt.datasource.password" = "/run/keys/dependency-track-db-password";
        "dt.ldap.bind-password" = "/run/keys/dependency-track-ldap-bind-password";
      };
      description = ''
        Properties whose values Dependency-Track reads from files.
        Use it for secrets, which must stay out of the Nix store.
      '';
    };

    database.createLocally = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to create a local PostgreSQL database and connect to it over its Unix socket.
      '';
    };

    frontend.settings = lib.mkOption {
      type = lib.types.submodule { freeformType = frontendSettingsFormat.type; };
      default = { };
      example = {
        OIDC_ISSUER = "https://auth.example.com";
        OIDC_CLIENT_ID = "dependency-track";
      };
      description = ''
        Configuration of the frontend. Values override the defaults in its
        [`config.json`](https://github.com/DependencyTrack/frontend/blob/main/public/static/config.json).
      '';
    };

    nginx = {
      enable = lib.mkEnableOption "an nginx virtual host for the frontend and the API" // {
        default = true;
        example = false;
      };

      domain = lib.mkOption {
        type = lib.types.str;
        example = "dtrack.example.com";
        description = "Domain name of the virtual host.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.dependency-track.settings = lib.mapAttrs (
      name: _: "\${file::/run/credentials/dependency-track.service/${name}}"
    ) cfg.credentials;

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      virtualHosts.${cfg.nginx.domain} = {
        locations = {
          "/" = {
            alias = "${cfg.package.frontend}/";
            index = "index.html";
            tryFiles = "$uri $uri/ /index.html";
            extraConfig = ''
              location ~ (index\.html)$ {
                add_header Cache-Control "max-age=0, no-cache, no-store, must-revalidate";
                add_header Pragma "no-cache";
                add_header Expires 0;
              }
            '';
          };
          "/api" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            recommendedProxySettings = true;
            # Dependency-Track enforces its own upload limits.
            extraConfig = "client_max_body_size 0;";
          };
          "= /static/config.json" = {
            alias = frontendConfig;
            extraConfig = ''
              add_header Cache-Control "max-age=0, no-cache, no-store, must-revalidate";
              add_header Pragma "no-cache";
              add_header Expires 0;
            '';
          };
        };
      };
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.settings."dt.datasource.username" ];
      ensureUsers = [
        {
          name = cfg.settings."dt.datasource.username";
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services.dependency-track = {
      description = "Dependency-Track";
      wantedBy = [ "multi-user.target" ];
      requires = lib.optional cfg.database.createLocally "postgresql.target";
      after = [ "network.target" ] ++ lib.optional cfg.database.createLocally "postgresql.target";
      environment.JDK_JAVA_OPTIONS = lib.mkIf (cfg.extraArgs != [ ]) (lib.escapeShellArgs cfg.extraArgs);
      serviceConfig = {
        ExecStartPre = lib.mkIf cfg.database.createLocally checkDatabase;
        ExecStart = "${lib.getExe cfg.package} -port ${toString cfg.port}";
        WorkingDirectory = workingDirectory;
        LoadCredential = lib.mapAttrsToList (name: path: "${name}:${path}") cfg.credentials;

        DynamicUser = true;
        User =
          if cfg.database.createLocally then cfg.settings."dt.datasource.username" else "dependency-track";
        StateDirectory = "dependency-track";
        StateDirectoryMode = "0700";
        Restart = "on-failure";

        CapabilityBoundingSet = "";
        LockPersonality = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [
      e1mo
      xanderio
    ];
  };
}
