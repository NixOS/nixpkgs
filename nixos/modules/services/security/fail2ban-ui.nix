{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.fail2ban-ui;
in
{
  options.services.fail2ban-ui = {
    enable = lib.mkEnableOption "fail2ban-ui";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.fail2ban-ui;
      defaultText = lib.literalExpression "pkgs.fail2ban-ui";
      description = ''
        The package that runs fail2ban-ui.
      '';
    };

    openFirewall = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Open ports in the firewall for the AdGuard Home web interface. Does not
        open the port needed to access the DNS resolver.
      '';
    };

    host = lib.mkOption {
      default = "0.0.0.0";
      type = lib.types.str;
      description = ''
        Host address to bind HTTP server to.
      '';
    };

    port = lib.mkOption {
      default = 3000;
      type = lib.types.port;
      description = ''
        Port to serve HTTP pages on.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.fail2ban-ui = {
      description = "fail2ban-ui";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig = {
        StartLimitIntervalSec = 5;
        StartLimitBurst = 10;
      };

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package}";
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        Restart = "always";
        RestartSec = 10;
        RuntimeDirectory = "fail2ban-ui";
        StateDirectory = "fail2ban-ui";
        SystemCallFilter = [
          "@system-service"
        ];
        SystemCallArchitectures = "native";
        DevicePolicy = "closed";
        LockPersonality = true;
        NoNewPrivileges = true;
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
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_NETLINK"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        UMask = "0077";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
