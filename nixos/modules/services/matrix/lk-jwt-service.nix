{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.lk-jwt-service;
in
{
  meta.maintainers = [ lib.maintainers.quadradical ];
  options.services.lk-jwt-service = {
    enable = lib.mkEnableOption "lk-jwt-service";
    package = lib.mkPackageOption pkgs "lk-jwt-service" { };

    livekitUrl = lib.mkOption {
      type = lib.types.strMatching "^wss?://.*";
      example = "wss://example.com/livekit/sfu";
      description = ''
        The public websocket URL for livekit.
        The proto needs to be either  `wss://` (recommended) or `ws://` (insecure).
      '';
    };

    keyFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to a file containing the credential mapping (`<keyname>: <secret>`) to access LiveKit.

        Example:
        `lk-jwt-service: f6lQGaHtM5HfgZjIcec3cOCRfiDqIine4CpZZnqdT5cE`

        For more information, see <https://github.com/element-hq/lk-jwt-service#configuration>.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port that lk-jwt-service should listen on.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.lk-jwt-service = {
      description = "Minimal service to issue LiveKit JWTs for MatrixRTC";
      documentation = [ "https://github.com/element-hq/lk-jwt-service" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = {
        LIVEKIT_URL = cfg.livekitUrl;
        LIVEKIT_JWT_PORT = toString cfg.port;
        LIVEKIT_KEY_FILE = "/run/credentials/lk-jwt-service.service/livekit-secrets";
      };

      serviceConfig = {
        LoadCredential = [ "livekit-secrets:${cfg.keyFile}" ];
        ExecStart = lib.getExe cfg.package;
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        ProtectHome = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        Restart = "on-failure";
        RestartSec = 5;
        UMask = "077";
      };
    };
  };
}
