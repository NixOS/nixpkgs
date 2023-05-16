<<<<<<< HEAD
{ config
, lib
, pkgs
, options
}:
=======
{ config, lib, pkgs, options }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

with lib;

let
  cfg = config.services.prometheus.exporters.unbound;
in
{
<<<<<<< HEAD
  imports = [
    (mkRemovedOptionModule [ "controlInterface" ] "This option was removed, use the `unbound.host` option instead.")
    (mkRemovedOptionModule [ "fetchType" ] "This option was removed, use the `unbound.host` option instead.")
    ({ options.warnings = options.warnings; options.assertions = options.assertions; })
  ];

  port = 9167;
  extraOpts = {
=======
  port = 9167;
  extraOpts = {
    fetchType = mkOption {
      # TODO: add shm when upstream implemented it
      type = types.enum [ "tcp" "uds" ];
      default = "uds";
      description = lib.mdDoc ''
        Which methods the exporter uses to get the information from unbound.
      '';
    };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = lib.mdDoc ''
        Path under which to expose metrics.
      '';
    };

<<<<<<< HEAD
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
=======
    controlInterface = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/run/unbound/unbound.socket";
      description = lib.mdDoc ''
        Path to the unbound socket for uds mode or the control interface port for tcp mode.

        Example:
          uds-mode: /run/unbound/unbound.socket
          tcp-mode: 127.0.0.1:8953
      '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  serviceOpts = mkMerge ([{
    serviceConfig = {
<<<<<<< HEAD
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
=======
      ExecStart = ''
        ${pkgs.prometheus-unbound-exporter}/bin/unbound-telemetry \
          ${cfg.fetchType} \
          --bind ${cfg.listenAddress}:${toString cfg.port} \
          --path ${cfg.telemetryPath} \
          ${optionalString (cfg.controlInterface != null) "--control-interface ${cfg.controlInterface}"} \
          ${toString cfg.extraFlags}
      '';
      RestrictAddressFamilies = [
        # Need AF_UNIX to collect data
        "AF_UNIX"
      ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  }] ++ [
    (mkIf config.services.unbound.enable {
      after = [ "unbound.service" ];
      requires = [ "unbound.service" ];
    })
  ]);
}
