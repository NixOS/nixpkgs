{ config, lib, pkgs, ... }:

with lib;

{
  options = {

    services.v2ray = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run v2ray server.

          Either <literal>configFile</literal> or <literal>config</literal> must be specified.
        '';
      };

      configFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/etc/v2ray/config.json";
        description = ''
          The absolute path to the configuration file.

          Either <literal>configFile</literal> or <literal>config</literal> must be specified.

          See <link xlink:href="https://www.v2fly.org/en_US/config/overview.html"/>.
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
        description = ''
          The configuration object.

          Either `configFile` or `config` must be specified.

          See <link xlink:href="https://www.v2fly.org/en_US/config/overview.html"/>.
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
          ${pkgs.v2ray}/bin/v2ray -test -config $out
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
      path = [ pkgs.v2ray ];
      script = ''
        exec v2ray -config ${configFile}
      '';
    };
  };
}
