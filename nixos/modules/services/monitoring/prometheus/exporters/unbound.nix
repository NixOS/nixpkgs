{ config
, lib
, pkgs
, options
}:

with lib;

let
  cfg = config.services.prometheus.exporters.unbound;
in
{
  imports = [
    (mkRemovedOptionModule [ "controlInterface" ] "This option was removed, use the `unbound.host` option instead.")
    (mkRemovedOptionModule [ "fetchType" ] "This option was removed, use the `unbound.host` option instead.")
    ({ options.warnings = options.warnings; options.assertions = options.assertions; })
  ];

  port = 9167;
  extraOpts = {
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = lib.mdDoc ''
        Path under which to expose metrics.
      '';
    };

    unbound = {
      ca = mkOption {
        type = types.nullOr types.path;
        default = "/var/lib/unbound/unbound_server.pem";
        example = null;
        description = ''
          Path to the Unbound server certificate authority
        '';
      };

      certificate = mkOption {
        type = types.nullOr types.path;
        default = "/var/lib/unbound/unbound_control.pem";
        example = null;
        description = ''
          Path to the Unbound control socket certificate
        '';
      };

      key = mkOption {
        type = types.nullOr types.path;
        default = "/var/lib/unbound/unbound_control.key";
        example = null;
        description = ''
          Path to the Unbound control socket key.
        '';
      };

      host = mkOption {
        type = types.str;
        default = "tcp://127.0.0.1:8953";
        example = "unix:///run/unbound/unbound.socket";
        description = lib.mdDoc ''
          Path to the unbound control socket. Supports unix domain sockets, as well as the TCP interface.
        '';
      };
    };
  };

  serviceOpts = mkMerge ([{
    serviceConfig = {
      User = "unbound"; # to access the unbound_control.key
      ExecStart = ''
        ${pkgs.prometheus-unbound-exporter}/bin/unbound_exporter \
          --unbound.host "${cfg.unbound.host}" \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          ${optionalString (cfg.unbound.ca != null) "--unbound.ca ${cfg.unbound.ca}"} \
          ${optionalString (cfg.unbound.certificate != null) "--unbound.cert ${cfg.unbound.certificate}"} \
          ${optionalString (cfg.unbound.key != null) "--unbound.key ${cfg.unbound.key}"} \
          ${toString cfg.extraFlags}
      '';
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
      ];
    } // optionalAttrs (!config.services.unbound.enable) {
      DynamicUser = true;
    };
  }] ++ [
    (mkIf config.services.unbound.enable {
      after = [ "unbound.service" ];
      requires = [ "unbound.service" ];
    })
  ]);
}
