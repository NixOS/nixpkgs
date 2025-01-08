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
    lib.mkOption
    mkPackageOption
    getExe
    types
    ;
in
{
  meta.maintainers = [ lib.maintainers.drupol ];

  options = {
    services.tika = {
      enable = lib.mkEnableOption "Apache Tika server";
      package = lib.mkPackageOption pkgs "tika" { };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = ''
          The Apache Tika bind address.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 9998;
        description = ''
          The Apache Tike port to listen on
        '';
      };

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The Apache Tika configuration (XML) file to use.
        '';
        example = lib.literalExpression "./tika/tika-config.xml";
      };

      enableOcr = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable OCR support by adding the `tesseract` package as a dependency.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open the firewall for Apache Tika.
          This adds `services.tika.port` to `networking.firewall.allowedTCPPorts`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.tika = {
      description = "Apache Tika Server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig =
        let
          package = cfg.package.override { inherit (cfg) enableOcr; };
        in
        {
          Type = "simple";

          ExecStart = "${getExe package} --host ${cfg.listenAddress} --port ${toString cfg.port} ${
            lib.optionalString (cfg.configFile != null) "--config ${cfg.configFile}"
          }";
          DynamicUser = true;
          StateDirectory = "tika";
          CacheDirectory = "tika";
        };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
