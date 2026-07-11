{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.kthxbye;
in

{
  options.services.kthxbye = {
    enable = lib.mkEnableOption "kthxbye alert acknowledgement management daemon";

    package = lib.mkPackageOption pkgs "kthxbye" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open ports in the firewall needed for the daemon to function.
      '';
    };

    extraOptions = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = ''
        Extra command line options.

        Documentation can be found [here](https://github.com/prymitive/kthxbye/blob/main/README.md).
      '';
      example = lib.literalExpression ''
        [
          "-extend-with-prefix 'ACK!'"
        ];
      '';
    };

    alertmanager = {
      timeout = lib.mkOption {
        type = lib.types.str;
        default = "1m0s";
        description = ''
          Alertmanager request timeout duration in the [time.Duration](https://pkg.go.dev/time#ParseDuration) format.
        '';
        example = "30s";
      };
      uri = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:9093";
        description = ''
          Alertmanager URI to use.
        '';
        example = "https://alertmanager.example.com";
      };
    };

    extendBy = lib.mkOption {
      type = lib.types.str;
      default = "15m0s";
      description = ''
        Extend silences by adding DURATION seconds.

        DURATION should be provided in the [time.Duration](https://pkg.go.dev/time#ParseDuration) format.
      '';
      example = "6h0m0s";
    };

    extendIfExpiringIn = lib.mkOption {
      type = lib.types.str;
      default = "5m0s";
      description = ''
        Extend silences that are about to expire in the next DURATION seconds.

        DURATION should be provided in the [time.Duration](https://pkg.go.dev/time#ParseDuration) format.
      '';
      example = "1m0s";
    };

    extendWithPrefix = lib.mkOption {
      type = lib.types.str;
      default = "ACK!";
      description = ''
        Extend silences with comment starting with PREFIX string.
      '';
      example = "!perma-silence";
    };

    interval = lib.mkOption {
      type = lib.types.str;
      default = "45s";
      description = ''
        Silence check interval duration in the [time.Duration](https://pkg.go.dev/time#ParseDuration) format.
      '';
      example = "30s";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = ''
        The address to listen on for HTTP requests.
      '';
      example = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = ''
        The port to listen on for HTTP requests.
      '';
    };

    logJSON = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Format logged messages as JSON.
      '';
    };

    maxDuration = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = ''
        Maximum duration of a silence, it won't be extended anymore after reaching it.

        Duration should be provided in the [time.Duration](https://pkg.go.dev/time#ParseDuration) format.
      '';
      example = "30d";
    };
  };

  config = lib.mkIf cfg.enable {
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
          ${lib.optionalString cfg.logJSON "-log-json"} \
          ${lib.optionalString (cfg.maxDuration != null) "-max-duration ${cfg.maxDuration}"} \
          ${lib.concatStringsSep " " cfg.extraOptions}
      '';
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        Restart = "on-failure";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
