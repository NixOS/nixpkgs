{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.prometheus.exporters.opnsense;
  inherit (lib)
    mkOption
    types
    optionalString
    concatStringsSep
    concatMapStringsSep
    ;
in
{
  port = 9144;
  extraOpts = {
    opnsenseServerAddress = mkOption {
      type = types.str;
      default = "192.168.1.1";
      example = "192.168.100.254";
      description = ''
        Opnsense IP address of the opnsense appliance.
        Defaults to 192.168.1.1
      '';
    };
    opnsenseServerProtocol = mkOption {
      type = types.enum [
        "http"
        "https"
      ];
      default = "https";
      example = "http";
      description = ''
        Opnsense metrics scraper protocol to use.
        Defaults to https.
      '';
    };
    apiKeyFile = mkOption {
      type = types.nullOr types.path;
      description = ''
        File containing the api key.
      '';
    };
    apiSecretFile = mkOption {
      type = types.nullOr types.path;
      description = ''
        File containing the api secret.
      '';
    };
    user = mkOption {
      type = types.str;
      default = "opnsense";
      description = ''
        User name under which the opensense exporter shall be run.
      '';
    };
    group = mkOption {
      type = types.str;
      default = "opnsense";
      description = ''
        Group under which the opnsense exporter shall be run.
      '';
    };
    enabledExporter = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "disable-openvpn" ];
      description = ''
        Collectors to enable or disable.
        All collectors are enabled by default.
      '';
    };
    disabledExporter = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "disable-openvpn" ];
      description = ''
        Collectors to enable or disable.
        All collectors are enabled by default.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      LoadCredential = [
        "${optionalString (cfg.apiKeyFile != null) "opnsense.api-key=${cfg.apiKeyFile}"}"
        "${optionalString (cfg.apiSecretFile != null) "opnsense.api-secret=${cfg.apiSecretFile}"}"
      ];
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      ProtectClock = true;
      ProtectSystem = "strict";
      Restart = "on-failure";
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      ExecStart = ''
        ${lib.getExe pkgs.prometheus-opnsense-exporter} \
          ${concatMapStringsSep " " (x: "--exporter." + x) cfg.enabledExporter} \
          ${concatMapStringsSep " " (x: "--no-exporter." + x) cfg.disabledExporter} \
          --opnsense.address ${cfg.opnsenseServerAddress} \
          --opnsense.protocol ${cfg.opnsenseServerProtocol} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " " cfg.extraFlags}
      '';
    };
  };
}
