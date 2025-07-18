{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.tuya-smartplug;
in
{
  port = 9999;
  extraOpts = {
    logLevel = lib.mkOption {
      type = lib.types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];
      default = "info";
      description = ''
        Detail level to log.
      '';
    };

    addr = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1:9999";
      description = ''
        Mailman3 Core REST API address.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "restadmin";
      description = ''
        Mailman3 Core REST API username.
      '';
    };

    passFile = lib.mkOption {
      type = lib.types.str;
      default = config.services.mailman.restApiPassFile;
      defaultText = lib.literalExpression "config.services.mailman.restApiPassFile";
      description = ''
        Mailman3 Core REST API password.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      LoadCredential = [
        "password:${cfg.mailman.passFile}"
      ];
      ExecStart =
        let
          addr = "${
            if (lib.hasInfix ":" cfg.listenAddress) then "[${cfg.listenAddress}]" else cfg.listenAddress
          }:${toString cfg.port}";
        in
        ''
          ${lib.getExe pkgs.prometheus-tuya-smartplug-exporter} \
            --log.level=${cfg.logLevel} \
            --web.listen-address=${addr} \
            --config.file="" \
            ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
        '';
    };
  };
}

