{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.services.guacamole-client;
  settingsFormat = pkgs.formats.javaProperties { };
in
{
  options = {
    services.guacamole-client = {
      enable = lib.mkEnableOption "Apache Guacamole Client (Tomcat)";
      package = lib.mkPackageOption pkgs "guacamole-client" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
        };
        default = {
          guacd-hostname = "localhost";
          guacd-port = 4822;
        };
        description = ''
          Configuration written to `guacamole.properties`.

          ::: {.note}
          The Guacamole web application uses one main configuration file called
          `guacamole.properties`. This file is the common location for all
          configuration properties read by Guacamole or any extension of
          Guacamole, including authentication providers.
          :::
        '';
      };

      enableWebserver = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable the Guacamole web application in a Tomcat webserver.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."guacamole/guacamole.properties" = lib.mkIf
      (cfg.settings != {})
      { source = (settingsFormat.generate "guacamole.properties" cfg.settings); };

    services = lib.mkIf cfg.enableWebserver {
      tomcat = {
        enable = true;
        webapps = [
          cfg.package
        ];
      };
    };
  };
}
