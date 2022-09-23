{ config, lib, pkgs, ... }:

with lib;

{
  options = {

    services.v2ray = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to run v2ray server.

          Either `configFile` or `config` must be specified.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.v2ray;
        defaultText = literalExpression "pkgs.v2ray";
        description = lib.mdDoc ''
          Which v2ray package to use.
        '';
      };

      configFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/etc/v2ray/config.json";
        description = lib.mdDoc ''
          The absolute path to the configuration file.

          Either `configFile` or `config` must be specified.

          See <https://www.v2fly.org/en_US/config/overview.html>.
        '';
      };

      config = mkOption {
        type = types.nullOr (types.attrsOf types.unspecified);
        default = null;
        example = {
          inbounds = [{
            port = 1080;
            listen = "127.0.0.1";
            protocol = "http";
          }];
          outbounds = [{
            protocol = "freedom";
          }];
        };
        description = lib.mdDoc ''
          The configuration object.

          Either `configFile` or `config` must be specified.

          See <https://www.v2fly.org/en_US/config/overview.html>.
        '';
      };
    };

  };

  config = let
    cfg = config.services.v2ray;
    configFile = if cfg.configFile != null
      then cfg.configFile
      else pkgs.writeTextFile {
        name = "v2ray.json";
        text = builtins.toJSON cfg.config;
        checkPhase = ''
          ${cfg.package}/bin/v2ray -test -config $out
        '';
      };

  in mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.configFile == null) != (cfg.config == null);
        message = "Either but not both `configFile` and `config` should be specified for v2ray.";
      }
    ];

    systemd.services.v2ray = {
      description = "v2ray Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/v2ray -config ${configFile}";
      };
    };
  };
}
