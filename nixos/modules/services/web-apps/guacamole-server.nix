{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.guacamole-server;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "guacamole-server" "logbackXml" ]
      [ "services" "guacamole-client" "logbackXml" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "guacamole-server" "userMappingXml" ]
      [ "services" "guacamole-client" "userMappingXml" ]
    )
  ];
  options = {
    services.guacamole-server = {
      enable = lib.mkEnableOption "Apache Guacamole Server (guacd)";
      package = lib.mkPackageOption pkgs "guacamole-server" { };

      extraEnvironment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = lib.literalExpression ''
          {
            ENVIRONMENT = "production";
          }
        '';
        description = "Environment variables to pass to guacd.";
      };

      host = lib.mkOption {
        default = "127.0.0.1";
        description = ''
          The host name or IP address the server should listen to.
        '';
        type = lib.types.str;
      };

      port = lib.mkOption {
        default = 4822;
        description = ''
          The port the guacd server should listen to.
        '';
        type = lib.types.port;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.guacamole-server = {
      description = "Apache Guacamole server (guacd)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        HOME = "/run/guacamole-server";
      }
      // cfg.extraEnvironment;
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
