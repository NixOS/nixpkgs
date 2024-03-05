{ config, lib, pkgs, options }:

with lib;

let
  logPrefix = "services.prometheus.exporter.ipmi";
  cfg = config.services.prometheus.exporters.ipmi;
in {
  port = 9290;

  extraOpts = {
    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Path to configuration file.
      '';
    };

    webConfigFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Path to configuration file that can enable TLS or authentication.
      '';
    };
  };

  serviceOpts.serviceConfig = {
    ExecStart = with cfg; concatStringsSep " " ([
      "${pkgs.prometheus-ipmi-exporter}/bin/ipmi_exporter"
      "--web.listen-address ${listenAddress}:${toString port}"
    ] ++ optionals (cfg.webConfigFile != null) [
      "--web.config.file ${escapeShellArg cfg.webConfigFile}"
    ] ++ optionals (cfg.configFile != null) [
      "--config.file ${escapeShellArg cfg.configFile}"
    ] ++ extraFlags);

    ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
    RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
  };
}
