{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.qbittorrent-nox;
in
{
  meta = {
    doc = ./qbittorrent-nox.md;
    maintainers = with lib.maintainers; [ redhawk ];
  };

  options.services.qbittorrent-nox = {
    enable = lib.mkEnableOption "qBittorrent-nox headless";

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/qbittorrent-nox";
      description = "The directory where qBittorrent-nox stores its data files.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open services.qbittorrent-nox.port to the outside network.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "qbittorrent-nox";
      description = "User account under which qBittorrent-nox runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "qbittorrent-nox";
      description = "Group under which qBittorrent-nox runs.";
    };

    webui-port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "qBittorrent-nox web UI port.";
    };

    package = lib.mkPackageOption pkgs "qbittorrent-nox" { };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.webui-port ]; };

    systemd = {
      services.qbittorrent-nox = {
        description = "qBittorrent-nox service";
        documentation = [ "man:qbittorrent-nox(1)" ];
        after = [
          "network-online.target"
          "nss-lookup.target"
        ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;

          ExecStart = "${lib.getExe cfg.package} --webui-port=${toString cfg.webui-port}";

          IOSchedulingClass = "idle";
          IOSchedulingPriority = "7";

          Restart = "always";
          UMask = "0022";

          PrivateTmp = false;
          PrivateNetwork = false;
          RemoveIPC = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectHome = "yes";
          ProtectProc = "invisible";
          ProcSubset = "pid";
          ProtectSystem = "full";
          ProtectClock = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          SystemCallArchitectures = "native";
          CapabilityBoundingSet = "";
          SystemCallFilter = [ "@system-service" ];

        };
        environment.QBT_PROFILE = cfg.dataDir; # required
      };

      tmpfiles.settings."qbittorrent-nox" = {
        "${cfg.dataDir}" = {
          d = {
            user = cfg.user;
            group = cfg.group;
            mode = "0755";
          };
        };
      };
    };

    users = {
      users = lib.mkIf (cfg.user == "qbittorrent-nox") {
        qbittorrent-nox = {
          group = cfg.group;
          isSystemUser = true;
        };
      };

      groups = lib.mkIf (cfg.group == "qbittorrent-nox") {
        qbittorrent-nox = { };

      };
    };
  };
}
