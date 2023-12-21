{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.services.guacamole-server;
in
{
  options = {
    services.guacamole-server = {
      enable = lib.mkEnableOption (lib.mdDoc "Apache Guacamole Server (guacd)");
      package = lib.mkPackageOptionMD pkgs "guacamole-server" { };

      extraEnvironment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = lib.literalExpression ''
          {
            ENVIRONMENT = "production";
          }
        '';
        description = lib.mdDoc "Environment variables to pass to guacd.";
      };

      host = lib.mkOption {
        default = "127.0.0.1";
        description = lib.mdDoc ''
          The host name or IP address the server should listen to.
        '';
        type = lib.types.str;
      };

      port = lib.mkOption {
        default = 4822;
        description = lib.mdDoc ''
          The port the guacd server should listen to.
        '';
        type = lib.types.port;
      };

      logbackXml = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/path/to/logback.xml";
        description = lib.mdDoc ''
          Configuration file that correspond to `logback.xml`.
        '';
      };

      userMappingXml = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/path/to/user-mapping.xml";
        description = lib.mdDoc ''
          Configuration file that correspond to `user-mapping.xml`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Setup configuration files.
    environment.etc."guacamole/logback.xml" = lib.mkIf (cfg.logbackXml != null) { source = cfg.logbackXml; };
    environment.etc."guacamole/user-mapping.xml" = lib.mkIf (cfg.userMappingXml != null) { source = cfg.userMappingXml; };

    systemd.services.guacamole-server = {
      description = "Apache Guacamole server (guacd)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        HOME = "/run/guacamole-server";
      } // cfg.extraEnvironment;
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} -f -b ${cfg.host} -l ${toString cfg.port}";
        RuntimeDirectory = "guacamole-server";
        DynamicUser = true;
        PrivateTmp = "yes";
        Restart = "on-failure";
      };
    };
  };
}
