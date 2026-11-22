{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.mailman3;
in
{
  port = 9934;
  extraOpts = {
    logLevel = lib.mkOption {
      type = lib.types.enum [
        "debug"
        "info"
        "warning"
        "error"
        "critical"
      ];
      default = "info";
      description = ''
        Detail level to log.
      '';
    };

    mailman = {
      addr = lib.mkOption {
        type = lib.types.str;
        default = "http://127.0.0.1:8001";
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
          ${lib.getExe pkgs.prometheus-mailman3-exporter} \
            --log-level ${cfg.logLevel} \
            --web.listen ${addr} \
            --mailman.address ${cfg.mailman.addr} \
            --mailman.user ${cfg.mailman.user} \
            --mailman.password-file %d/password \
            ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
        '';
    };
  };
}
