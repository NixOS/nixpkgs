{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tika;
  inherit (lib)
    literalExpression
    mkIf
    mkEnableOption
    mkOption
    mkPackageOption
    getExe
    types
    ;
in
{
  meta.maintainers = [ lib.maintainers.drupol ];

  options = {
    services.tika = {
      enable = mkEnableOption "Apache Tika server";
      package = mkPackageOption pkgs "tika" { };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = ''
          The Apache Tika bind address.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 9998;
        description = ''
          The Apache Tike port to listen on
        '';
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          The Apache Tika configuration (XML) file to use.
        '';
        example = literalExpression "./tika/tika-config.xml";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the firewall for Apache Tika.
          This adds `services.tika.port` to `networking.firewall.allowedTCPPorts`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.tika = {
      description = "Apache Tika Server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";

        ExecStart = "${getExe cfg.package} --host ${cfg.listenAddress} --port ${toString cfg.port} ${lib.optionalString (cfg.configFile != null) "--config ${cfg.configFile}"}";
        DynamicUser = true;
        StateDirectory = "tika";
        CacheDirectory = "tika";
      };
    };

    networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
