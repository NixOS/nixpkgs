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
        Open ports in the firewall for the fail2ban-ui web interface.
      '';
    };

    host = lib.mkOption {
      default = "0.0.0.0";
      type = lib.types.str;
      description = ''
        Host address to bind the fail2ban-ui web interface to
      '';
    };

    port = lib.mkOption {
      default = 3000;
      type = lib.types.port;
      description = ''
        Port to bind the fail2ban-ui web interface to
      '';
    };

    user = lib.mkOption {
      default = "fail2ban-ui";
      type = lib.types.str;
    };

    group = lib.mkOption {
      default = "fail2ban-ui";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.fail2ban-ui = {
      description = "fail2ban-ui";
      after = [
        "network.target"
        "fail2ban.service"
      ];
      wantedBy = [ "multi-user.target" ];
      partOf = lib.optional config.networking.firewall.enable "firewall.service";

      environment = {
        HOME = "/var/lib/fail2ban-ui";
        PORT = toString cfg.port;
        BIND_ADDRESS = cfg.host;
        UPDATE_CHECK = toString false;
      };

      unitConfig = {
        StartLimitIntervalSec = 5;
        StartLimitBurst = 10;
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        DynamicUser = "yes";

        ExecStart = "${lib.getExe cfg.package}";

        Restart = "always";
        RestartSec = 10;

        RuntimeDirectory = "fail2ban-ui";
        RuntimeDirectoryMode = "0700";
        RuntimeDirectoryPreserve = true;
        ReadWritePaths = [ "/var/lib/fail2ban-ui" ];
        WorkingDirectory = "/var/lib/fail2ban-ui";
        StateDirectory = "fail2ban-ui";
        StateDirectoryMode = "0750";

        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
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
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
