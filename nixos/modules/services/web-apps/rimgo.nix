{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.rimgo;
  inherit (lib)
    mkOption
    mkEnableOption
    mkPackageOption
    mkDefault
    mkIf
    types
    literalExpression
    optionalString
    getExe
    mapAttrs
    ;
in
{
  options.services.rimgo = {
    enable = mkEnableOption "rimgo";
    package = mkPackageOption pkgs "rimgo" { };
    settings = mkOption {
      type = types.submodule {
        freeformType = with types; attrsOf str;
        options = {
          PORT = mkOption {
            type = types.port;
            default = 3000;
            example = 69420;
            description = "The port to use.";
          };
          ADDRESS = mkOption {
            type = types.str;
            default = "127.0.0.1";
            example = "1.1.1.1";
            description = "The address to listen on.";
          };
        };
      };
      example = literalExpression ''
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

  config = mkIf cfg.enable {
    systemd.services.rimgo = {
      description = "Rimgo";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = mapAttrs (_: toString) cfg.settings;
      serviceConfig = {
        ExecStart = getExe cfg.package;
        AmbientCapabilities = mkIf (cfg.settings.PORT < 1024) [
          "CAP_NET_BIND_SERVICE"
        ];
        DynamicUser = true;
        Restart = "on-failure";
        RestartSec = "5s";
        CapabilityBoundingSet = [
          (optionalString (cfg.settings.PORT < 1024) "CAP_NET_BIND_SERVICE")
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
