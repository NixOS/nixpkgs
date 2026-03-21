{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    boolToString
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.firezone.relay;
in
{
  options = {
    services.firezone.relay = {
      enable = mkEnableOption "the firezone relay server";
      package = mkPackageOption pkgs "firezone-relay" { };

      name = mkOption {
        type = types.str;
        example = "My relay";
        description = "The name of this gateway as shown in firezone";
      };

      publicIpv4 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The public ipv4 address of this relay";
      };

      publicIpv6 = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The public ipv6 address of this relay";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = "Opens up the main STUN port and the TURN allocation range.";
      };

      port = mkOption {
        type = types.port;
        default = 3478;
        description = "The port to listen on for STUN messages";
      };

      lowestPort = mkOption {
        type = types.port;
        default = 49152;
        description = "The lowest port to use in TURN allocation";
      };

      highestPort = mkOption {
        type = types.port;
        default = 65535;
        description = "The highest port to use in TURN allocation";
      };

      apiUrl = mkOption {
        type = types.strMatching "^wss://.+/$";
        example = "wss://firezone.example.com/api/";
        description = ''
          The URL of your firezone server's API. This should be the same
          as your server's setting for {option}`services.firezone.server.settings.api.externalUrl`,
          but with `wss://` instead of `https://`.
        '';
      };

      tokenFile = mkOption {
        type = types.path;
        example = "/run/secrets/firezone-relay-token";
        description = ''
          A file containing the firezone relay token. Do not use a nix-store path here
          as it will make the token publicly readable!

          This file will be passed via systemd credentials, it should only be accessible
          by the root user.
        '';
      };

      logLevel = mkOption {
        type = types.str;
        default = "info";
        description = ''
          The log level for the firezone application. See
          [RUST_LOG](https://docs.rs/env_logger/latest/env_logger/#enabling-logging)
          for the format.
        '';
      };

      enableTelemetry = mkEnableOption "telemetry";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.publicIpv4 != null || cfg.publicIpv6 != null;
        message = "At least one of `services.firezone.relay.publicIpv4` and `services.firezone.relay.publicIpv6` must be set";
      }
    ];

    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [ cfg.port ];
    networking.firewall.allowedUDPPortRanges = mkIf cfg.openFirewall [
      {
        from = cfg.lowestPort;
        to = cfg.highestPort;
      }
    ];

    systemd.services.firezone-relay = {
      description = "relay service for the Firezone zero-trust access platform";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.util-linux ];
      script = ''
        # If FIREZONE_ID is not given by the user, use a persisted (or newly generated) uuid.
        if [[ -z "''${FIREZONE_ID:-}" ]]; then
          if [[ ! -e relay_id ]]; then
            uuidgen -r > relay_id
          fi
          export FIREZONE_ID=$(< relay_id)
        fi

        export FIREZONE_TOKEN=$(< "$CREDENTIALS_DIRECTORY/firezone-token")
        exec ${getExe cfg.package}
      '';

      environment = {
        FIREZONE_API_URL = cfg.apiUrl;
        FIREZONE_NAME = cfg.name;
        FIREZONE_TELEMETRY = boolToString cfg.enableTelemetry;

        PUBLIC_IP4_ADDR = cfg.publicIpv4;
        PUBLIC_IP6_ADDR = cfg.publicIpv6;

        LISTEN_PORT = toString cfg.port;
        LOWEST_PORT = toString cfg.lowestPort;
        HIGHEST_PORT = toString cfg.highestPort;

        RUST_LOG = cfg.logLevel;
        LOG_FORMAT = "human";
      };

      serviceConfig = {
        Type = "exec";
        DynamicUser = true;
        User = "firezone-relay";
        LoadCredential = [ "firezone-token:${cfg.tokenFile}" ];

        StateDirectory = "firezone-relay";
        WorkingDirectory = "/var/lib/firezone-relay";

        Restart = "on-failure";
        RestartSec = 10;

        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = false;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        UMask = "077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    oddlama
    patrickdag
  ];
}
