{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.yaiiu-immich-proxy;
  inherit (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
in
{
  options.services.yaiiu-immich-proxy = {
    enable = mkEnableOption "YAIIU Immich Proxy";
    package = lib.mkPackageOption pkgs "yaiiu-immich-proxy" { };

    immichUrl = mkOption {
      type = types.str;
      description = "URL of the Immich instance";
      example = "http://localhost:2283";
    };

    port = mkOption {
      type = types.port;
      default = 2282;
      description = "The port that yaiiu-immich-proxy will listen on.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the yaiiu-immich-proxy port in the firewall";
    };

    environment = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf (types.either types.str types.int);
        options = {
          IMMICH_SERVER_URL = mkOption {
            type = types.str;
            default = cfg.immichUrl;
            defaultText = "\${cfg.immichUrl}";
            description = "URL of the Immich instance";
          };
          LISTEN_ADDR = mkOption {
            type = types.str;
            default = ":${toString cfg.port}";
            defaultText = ":\${toString cfg.port}";
            description = "The port that yaiiu-immich-proxy will listen on, prepended with a :";
          };
        };
      };
      default = { };
      description = ''
        Environment variables to be set for the service. Can use systemd specifiers.
        Only IMMICH_SERVER_URL and LISTEN_ADDR are used directly by the program, and they're set by the immichUrl and port options.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.yaiiu-immich-proxy = {
      description = "A proxy server that sits between iOS background upload extension and Immich server. It handles the conversion of raw photo data to the multipart/form-data format required by Immich API.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = lib.mapAttrs (_: value: toString value) cfg.environment;
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        User = "yaiiu-immich-proxy";
        Group = "yaiiu-immich-proxy";
        DynamicUser = true;
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 3;

        # Hardening
        CapabilityBoundingSet = [ "" ];
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };
  meta.maintainers = [ lib.maintainers.luNeder ];
}
