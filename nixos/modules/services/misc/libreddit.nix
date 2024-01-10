{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.libreddit;

  args = concatStringsSep " " ([
    "--port ${toString cfg.port}"
    "--address ${cfg.address}"
  ]);
in
{
  options = {
    services.libreddit = {
      enable = mkEnableOption (lib.mdDoc "Private front-end for Reddit");

      package = mkPackageOption pkgs "libreddit" { };

      address = mkOption {
        default = "0.0.0.0";
        example = "127.0.0.1";
        type =  types.str;
        description = lib.mdDoc "The address to listen on";
      };

      port = mkOption {
        default = 8080;
        example = 8000;
        type = types.port;
        description = lib.mdDoc "The port to listen on";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the libreddit web interface";
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.services.libreddit = {
        description = "Private front-end for Reddit";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          DynamicUser = true;
          ExecStart = "${cfg.package}/bin/libreddit ${args}";
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

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
