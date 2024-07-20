{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  inherit (lib.types)
    attrsOf
    package
    port
    str
    ;

  cfg = config.services.crabfit;
in

{
  options.services.crabfit = {
    enable = mkEnableOption "Crab Fit, a meeting scheduler based on peoples' availability";

    frontend = {
      package = mkPackageOption pkgs "crabfit-frontend" { };

      finalDrv = mkOption {
        readOnly = true;
        type = package;
        default = cfg.frontend.package.override {
          api_url = "https://${cfg.api.host}";
          frontend_url = cfg.frontend.host;
        };

        defaultText = literalExpression ''
          cfg.package.override {
            api_url = "https://''${cfg.api.host}";
            frontend_url = cfg.frontend.host;
          };
        '';

        description = ''
          The patched frontend, using the correct urls for the API and frontend.
        '';
      };

      environment = mkOption {
        type = attrsOf str;
        default = { };
        description = ''
          Environment variables for the crabfit frontend.
        '';
      };

      host = mkOption {
        type = str;
        description = ''
          The hostname of the frontend.
        '';
      };

      port = mkOption {
        type = port;
        default = 3001;
        description = ''
          The internal listening port of the frontend.
        '';
      };
    };

    api = {
      package = mkPackageOption pkgs "crabfit-api" { };

      environment = mkOption {
        type = attrsOf str;
        default = { };
        description = ''
          Environment variables for the crabfit API.
        '';
      };

      host = mkOption {
        type = str;
        description = ''
          The hostname of the API.
        '';
      };

      port = mkOption {
        type = port;
        default = 3000;
        description = ''
          The internal listening port of the API.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services = {
      crabfit-api = {
        description = "The API for Crab Fit.";

        wantedBy = [ "multi-user.target" ];
        after = [ "postgresql.service" ];

        serviceConfig = {
          # TODO: harden
          ExecStart = lib.getExe cfg.api.package;
          User = "crabfit";
        };

        environment = {
          API_LISTEN = "127.0.0.1:${builtins.toString cfg.api.port}";
          DATABASE_URL = "postgres:///crabfit?host=/run/postgresql";
          FRONTEND_URL = "https://${cfg.frontend.host}";
        } // cfg.api.environment;
      };

      crabfit-frontend = {
        description = "The frontend for Crab Fit.";

        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          # TODO: harden
          CacheDirectory = "crabfit";
          DynamicUser = true;
          ExecStart = "${lib.getExe pkgs.nodejs} standalone/server.js";
          WorkingDirectory = cfg.frontend.finalDrv;
        };

        environment = {
          NEXT_PUBLIC_API_URL = "https://${cfg.api.host}";
          PORT = builtins.toString cfg.frontend.port;
        } // cfg.frontend.environment;
      };
    };

    users = {
      groups.crabfit = { };

      users.crabfit = {
        group = "crabfit";
        isSystemUser = true;
      };
    };

    services = {
      postgresql = {
        enable = true;

        ensureDatabases = [ "crabfit" ];

        ensureUsers = [
          {
            name = "crabfit";
            ensureDBOwnership = true;
          }
        ];
      };
    };
  };
}
