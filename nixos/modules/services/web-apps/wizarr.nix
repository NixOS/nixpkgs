{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.wizarr;
in
{
  options.services.wizarr = {
    enable = lib.mkEnableOption "Wizarr, an advanced user invitation and management system for Jellyfin, Plex, Emby etc.";

    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = ''
        Host to bind Wizarr to.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5960;
      description = ''
        Port to bind Wizarr to.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to open the port in the firewall for Wizarr.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.wizarr = {
      description = "Wizarr - user invitation and management system";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment.DATABASE_DIR = "/var/lib/wizarr";

      script = ''
        ${lib.getExe pkgs.wizarr} -D \
          -b 0.0.0.0:${toString cfg.port} \
          --workers 3 \
          --log-level=info
      '';

      serviceConfig = {
        Type = "forking";

        DynamicUser = true;
        User = "wizarr";
        RuntimeDirectory = "wizarr";
        StateDirectory = "wizarr";

        # Hardening
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectHome = true;
        ProcSubset = "pid";

        PrivateTmp = true;
        PrivateNetwork = false;
        PrivateUsers = cfg.port >= 1024;
        PrivateDevices = true;

        RestrictRealtime = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];

        MemoryDenyWriteExecute = false; # Java does not like w^x :(
        LockPersonality = true;
        AmbientCapabilities = lib.optional (cfg.port < 1024) "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@resources"
          "~@privileged"
        ];
        UMask = "0027";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
