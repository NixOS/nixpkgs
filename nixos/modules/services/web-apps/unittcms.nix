{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.unittcms;
  # we have to override the setting here, because it gets baked into the web app.
  unittcms = cfg.package.override { defaultBackendOrigin = cfg.apiEndpoint; };
in
{
  options = {
    services.unittcms = {
      enable = lib.mkEnableOption ''
        Open source test case management system designed for self-hosted use.

        Due to modern browser security policies (CORS), a reverse proxy is
        required for this service to work correctly.

        Example nginx reverse proxy configuration:
        ```
        {
          services.nginx = {
            enable = true;
            virtualHosts."''${config.services.unittcms.hostname}".locations = {
              # The frontend will bind to hostname, which may not resolve to 127.0.0.1
              "/".proxyPass = "http://''${config.services.unittcms.hostname}:''${toString config.services.unittcms.frontendPort}/";
              # Backend address must have the trailing slash to rewrite correctly
              "/api/".proxyPass = "http://127.0.0.1:''${toString config.services.unittcms.backendPort}/";
            };
          };
        }
        ```
      '';

      package = lib.mkPackageOption pkgs "unittcms" { };

      backendPort = lib.mkOption {
        type = lib.types.port;
        default = 8001;
        example = 8001;
        description = ''
          The port under which the backend service should be accessible.

          You should reverse proxy this port from localhost to the `apiEndpoint`.
        '';
      };

      frontendPort = lib.mkOption {
        type = lib.types.port;
        default = 8000;
        example = 8000;
        description = ''
          The port under which the frontend service should be accessible.

          You should reverse proxy this port from localhost to the `hostname`.
        '';
      };

      hostname = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "test.example.org";
        description = ''
          The hostname under which the service should be accessible.

          Frontend will use this name for redirection, so it must match your
          reverse proxy's domain name.
        '';
      };

      apiEndpoint = lib.mkOption {
        type = lib.types.str;
        default = "/api";
        example = "/api";
        description = ''
          The path under which the backend API is accessible from the browser.
          This can be a relative path, which must be routeable under the `hostname`,
          or a full URL, which must have CORS policies configured to be accessible.
        '';
      };

      secretKeyFile = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/unittcms/secret_key";
        example = "/var/lib/unittcms/secret_key";
        description = ''
          A file containing the secret key for token generation.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      unittcms-backend = {
        wantedBy = [ "multi-user.target" ];
        description = "Open source test case management system: Backend";
        after = [ "network.target" ];
        path = with pkgs; [
          bash # used by sequelize
        ];
        environment = {
          PORT = toString cfg.backendPort;
          FRONTEND_ORIGIN = cfg.hostname;
        };
        preStart = ''
          ${lib.getExe' unittcms "unittcms-sequelize"} db:migrate
        '';
        serviceConfig = {
          LoadCredential = [
            "secretKey:${cfg.secretKeyFile}"
          ];
          DynamicUser = true;
          StateDirectory = "unittcms";
          WorkingDirectory = "/var/lib/unittcms";
        };
        script = ''
          set -eou pipefail

          export SECRET_KEY
          SECRET_KEY="$(<"$CREDENTIALS_DIRECTORY/secretKey")"
          ${lib.getExe' unittcms "unittcms-backend"}
        '';
      };

      unittcms-frontend = {
        wantedBy = [ "multi-user.target" ];
        description = "Open source test case management system: Frontend";
        after = [ "network.target" ];
        environment = {
          HOSTNAME = cfg.hostname;
          PORT = toString cfg.frontendPort;
        };
        serviceConfig = {
          ExecStart = "${lib.getExe' unittcms "unittcms-frontend"}";
          DynamicUser = true;
          CacheDirectory = "unittcms";
        };
      };
    };
  };
  meta.maintainers = with lib.maintainers; [ RadxaYuntian ];
}
