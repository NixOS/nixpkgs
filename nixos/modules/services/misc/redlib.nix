{ config, lib, pkgs, ... }:
let
  cfg = config.services.redlib;

  args = lib.concatStringsSep " " ([
    "--port ${toString cfg.port}"
    "--address ${cfg.address}"
  ]);
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "libreddit" ] [ "services" "redlib" ])
  ];

  options = {
    services.redlib = {
      enable = lib.mkEnableOption "Private front-end for Reddit";

      package = lib.mkPackageOption pkgs "redlib" { };

      address = lib.mkOption {
        default = "0.0.0.0";
        example = "127.0.0.1";
        type =  lib.types.str;
        description = "The address to listen on";
      };

      port = lib.mkOption {
        default = 8080;
        example = 8000;
        type = lib.types.port;
        description = "The port to listen on";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the redlib web interface";
      };

    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.redlib = {
        description = "Private front-end for Reddit";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          DynamicUser = true;
          ExecStart = "${lib.getExe cfg.package} ${args}";
          AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
          Restart = "on-failure";
          RestartSec = "2s";
          # Hardening
          CapabilityBoundingSet = if (cfg.port < 1024) then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
          DeviceAllow = [ "" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          PrivateDevices = true;
          # A private user cannot have process capabilities on the host's user
          # namespace and thus CAP_NET_BIND_SERVICE has no effect.
          PrivateUsers = (cfg.port >= 1024);
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
          UMask = "0077";
        };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
