{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.services.wiki-js;

  format = pkgs.formats.json { };

  configFile = format.generate "wiki-js.yml" cfg.settings;
in
{
  options.services.wiki-js = {
    enable = mkEnableOption "wiki-js";

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/root/wiki-js.env";
      description = ''
        Environment file to inject e.g. secrets into the configuration.
      '';
    };

    stateDirectoryName = mkOption {
      default = "wiki-js";
      type = types.str;
      description = ''
        Name of the directory in {file}`/var/lib`.
      '';
    };

    settings = mkOption {
      default = { };
      type = types.submodule {
        freeformType = format.type;
        options = {
          port = mkOption {
            type = types.port;
            default = 3000;
            description = ''
              TCP port the process should listen to.
            '';
          };

          bindIP = mkOption {
            default = "0.0.0.0";
            type = types.str;
            description = ''
              IPs the service should listen to.
            '';
          };

          db = {
            type = mkOption {
              default = "postgres";
              type = types.enum [
                "postgres"
                "mysql"
                "mariadb"
                "mssql"
              ];
              description = ''
                Database driver to use for persistence. Please note that `sqlite`
                is currently not supported as the build process for it is currently not implemented
                in `pkgs.wiki-js` and it's not recommended by upstream for
                production use.
              '';
            };
            host = mkOption {
              type = types.str;
              example = "/run/postgresql";
              description = ''
                Hostname or socket-path to connect to.
              '';
            };
            db = mkOption {
              default = "wiki";
              type = types.str;
              description = ''
                Name of the database to use.
              '';
            };
          };

          logLevel = mkOption {
            default = "info";
            type = types.enum [
              "error"
              "warn"
              "info"
              "verbose"
              "debug"
              "silly"
            ];
            description = ''
              Define how much detail is supposed to be logged at runtime.
            '';
          };

          offline = mkEnableOption "offline mode" // {
            description = ''
              Disable latest file updates and enable
              [sideloading](https://docs.requarks.io/install/sideload).
            '';
          };
        };
      };
      description = ''
        Settings to configure `wiki-js`. This directly
        corresponds to [the upstream configuration options](https://docs.requarks.io/install/config).

        Secrets can be injected via the environment by
        - specifying [](#opt-services.wiki-js.environmentFile)
          to contain secrets
        - and setting sensitive values to `$(ENVIRONMENT_VAR)`
          with this value defined in the environment-file.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.wiki-js.settings.dataPath = "/var/lib/${cfg.stateDirectoryName}";
    systemd.services.wiki-js = {
      description = "A modern and powerful wiki app built on Node.js";
      documentation = [ "https://docs.requarks.io/" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        # Needed for git storage.
        git
        # Needed for git+ssh storage.
        openssh
      ];

      preStart = ''
        ln -sf ${configFile} /var/lib/${cfg.stateDirectoryName}/config.yml
        ln -sf ${pkgs.wiki-js}/server /var/lib/${cfg.stateDirectoryName}
        ln -sf ${pkgs.wiki-js}/assets /var/lib/${cfg.stateDirectoryName}
        ln -sf ${pkgs.wiki-js}/package.json /var/lib/${cfg.stateDirectoryName}/package.json
      '';

      serviceConfig = {
        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
        StateDirectory = cfg.stateDirectoryName;
        WorkingDirectory = "/var/lib/${cfg.stateDirectoryName}";
        DynamicUser = true;
        PrivateTmp = true;
        ExecStart = "${pkgs.nodejs_20}/bin/node ${pkgs.wiki-js}/server";
      };
    };
  };

  meta.maintainers = with maintainers; [ ma27 ];
}
