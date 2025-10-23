{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.echoip;
in
{
  meta.maintainers = with lib.maintainers; [ defelo ];

  options.services.echoip = {
    enable = lib.mkEnableOption "echoip";

    package = lib.mkPackageOption pkgs "echoip" { };

    virtualHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        Name of the nginx virtual host to use and setup. If null, do not setup anything.
      '';
      default = null;
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Extra command line arguments to pass to echoip. See <https://github.com/mpolden/echoip> for details.";
      default = [ ];
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      description = "The address echoip should listen on";
      default = ":8080";
      example = "127.0.0.1:8000";
    };

    enablePortLookup = lib.mkEnableOption "port lookup";

    enableReverseHostnameLookups = lib.mkEnableOption "reverse hostname lookups";

    remoteIpHeader = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Header to trust for remote IP, if present";
      default = null;
      example = "X-Real-IP";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.echoip = {
      wantedBy = [ "multi-user.target" ];

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        User = "echoip";
        Group = "echoip";
        DynamicUser = true;
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "-l"
            cfg.listenAddress
          ]
          ++ lib.optional cfg.enablePortLookup "-p"
          ++ lib.optional cfg.enableReverseHostnameLookups "-r"
          ++ lib.optionals (cfg.remoteIpHeader != null) [
            "-H"
            cfg.remoteIpHeader
          ]
          ++ cfg.extraArgs
        );

        # Hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
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
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET AF_INET6 AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
          "setrlimit"
        ];
        UMask = "0077";
      };
    };

    services.nginx = lib.mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts.${cfg.virtualHost} = {
        locations."/" = {
          proxyPass = "http://${cfg.listenAddress}";
          recommendedProxySettings = true;
        };
      };
    };

    services.echoip = lib.mkIf (cfg.virtualHost != null) {
      listenAddress = lib.mkDefault "127.0.0.1:8080";
      remoteIpHeader = "X-Real-IP";
    };
  };
}
