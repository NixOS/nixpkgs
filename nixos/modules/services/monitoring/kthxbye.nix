{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.services.kthxbye;
in

{
  options.services.kthxbye = {
    enable = mkEnableOption (mdDoc "kthxbye alert acknowledgement management daemon");

    package = mkOption {
      type = types.package;
      default = pkgs.kthxbye;
      defaultText = literalExpression "pkgs.kthxbye";
      description = mdDoc ''
        The kthxbye package that should be used.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Whether to open ports in the firewall needed for the daemon to function.
      '';
    };

    extraOptions = mkOption {
      type = with types; listOf str;
      default = [];
      description = mdDoc ''
        Extra command line options.

        Documentation can be found [here](https://github.com/prymitive/kthxbye/blob/main/README.md).
      '';
      example = literalExpression ''
        [
          "-extend-with-prefix 'ACK!'"
        ];
      '';
    };

    alertmanager = {
      timeout = mkOption {
        type = types.str;
        default = "1m0s";
        description = mdDoc ''
          Alertmanager request timeout duration in the [time.Duration](https://pkg.go.dev/time#ParseDuration) format.
        '';
        example = "30s";
      };
      uri = mkOption {
        type = types.str;
        default = "http://localhost:9093";
        description = mdDoc ''
          Alertmanager URI to use.
        '';
        example = "https://alertmanager.example.com";
      };
    };

    extendBy = mkOption {
      type = types.str;
      default = "15m0s";
      description = mdDoc ''
        Extend silences by adding DURATION seconds.

        DURATION should be provided in the [time.Duration](https://pkg.go.dev/time#ParseDuration) format.
      '';
      example = "6h0m0s";
    };

    extendIfExpiringIn = mkOption {
      type = types.str;
      default = "5m0s";
      description = mdDoc ''
        Extend silences that are about to expire in the next DURATION seconds.

        DURATION should be provided in the [time.Duration](https://pkg.go.dev/time#ParseDuration) format.
      '';
      example = "1m0s";
    };

    extendWithPrefix = mkOption {
      type = types.str;
      default = "ACK!";
      description = mdDoc ''
        Extend silences with comment starting with PREFIX string.
      '';
      example = "!perma-silence";
    };

    interval = mkOption {
      type = types.str;
      default = "45s";
      description = mdDoc ''
        Silence check interval duration in the [time.Duration](https://pkg.go.dev/time#ParseDuration) format.
      '';
      example = "30s";
    };

    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = mdDoc ''
        The address to listen on for HTTP requests.
      '';
      example = "127.0.0.1";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = mdDoc ''
        The port to listen on for HTTP requests.
      '';
    };

    logJSON = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Format logged messages as JSON.
      '';
    };

    maxDuration = mkOption {
      type = with types; nullOr str;
      default = null;
      description = mdDoc ''
        Maximum duration of a silence, it won't be extended anymore after reaching it.

        Duration should be provided in the [time.Duration](https://pkg.go.dev/time#ParseDuration) format.
      '';
      example = "30d";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.kthxbye = {
      description = "kthxbye Alertmanager ack management daemon";
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${cfg.package}/bin/kthxbye \
          -alertmanager.timeout ${cfg.alertmanager.timeout} \
          -alertmanager.uri ${cfg.alertmanager.uri} \
          -extend-by ${cfg.extendBy} \
          -extend-if-expiring-in ${cfg.extendIfExpiringIn} \
          -extend-with-prefix ${cfg.extendWithPrefix} \
          -interval ${cfg.interval} \
          -listen ${cfg.listenAddress}:${toString cfg.port} \
          ${optionalString cfg.logJSON "-log-json"} \
          ${optionalString (cfg.maxDuration != null) "-max-duration ${cfg.maxDuration}"} \
          ${concatStringsSep " " cfg.extraOptions}
      '';
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        Restart = "on-failure";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };
}
