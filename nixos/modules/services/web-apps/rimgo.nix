{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.rimgo;
in
{
  options.services.rimgo = {
    enable = lib.mkEnableOption "rimgo";
    package = lib.mkPackageOption pkgs "rimgo" { };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = with lib.types; attrsOf str;
        options = {
          PORT = lib.mkOption {
            type = lib.types.port;
            default = 3000;
            example = 69420;
            description = "The port to use.";
          };
          ADDRESS = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            example = "1.1.1.1";
            description = "The address to listen on.";
          };
        };
      };
      example = lib.literalExpression ''
        {
          PORT = 69420;
          FORCE_WEBP = "1";
        }
      '';
      description = ''
        Settings for rimgo, see [the official documentation](https://rimgo.codeberg.page/docs/usage/configuration/) for supported options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.rimgo = {
      description = "Rimgo";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = lib.mapAttrs (_: toString) cfg.settings;
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        AmbientCapabilities = lib.mkIf (cfg.settings.PORT < 1024) [
          "CAP_NET_BIND_SERVICE"
        ];
        DynamicUser = true;
        Restart = "on-failure";
        RestartSec = "5s";
        CapabilityBoundingSet = [
          (lib.optionalString (cfg.settings.PORT < 1024) "CAP_NET_BIND_SERVICE")
        ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = cfg.settings.PORT >= 1024;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
}
