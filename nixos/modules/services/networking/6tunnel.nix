{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services._6tunnel;

in {
  options.services._6tunnel = {

    tunnels = mkOption {
      default = [];
      description = "Which tunnels to create.";
      type = with types; listOf (submodule {
        options = {
          port = mkOption {
            description = "Local port to open.";
            type = types.port;
          };
          remoteHost = mkOption {
            description = "Remote host to tunnel to.";
            type = types.str;
          };
          remotePort = mkOption {
            default = null;
            description = "Port on remote host. If null (default), it uses the the local port.";
            type = with types; nullOr port;
          };
          restart = mkOption {
            default = null;
            description = ''
              Whether to restart the tunnel periodically, which is useful for non-static IP addresses.
              The format is described in SYSTEMD.TIME(7).

              If null (default), the tunnel won't restart periodically.
            '';
            type = with types; nullOr str;
          };
        };
      });
      example = [
        { port = 8080; remoteHost = "192.168.0.2"; remotePort = 80; }
        { port = 443; remoteHost = "www.example.com"; }
        { port = 8053; remoteHost = "dynamicip.example.com"; restart = "1h"; }
      ];
    };

    openFirewall = mkOption {
      default = false;
      description = "Whether to open the local ports in the firewall.";
      type = types.bool;
    };

  };

  config = mkIf (cfg.tunnels != []) {

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall (map (tunnel: tunnel.port) cfg.tunnels);
    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall (map (tunnel: tunnel.port) cfg.tunnels);

    systemd.services = listToAttrs (map (tunnel:
      nameValuePair "6tunnel-${toString tunnel.port}" {
        description = "6tunnel from ${toString tunnel.port} to ${tunnel.remoteHost}${optionalString (tunnel.remotePort != null) ":${toString tunnel.remotePort}"}";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = ''
            ${pkgs._6tunnel}/bin/6tunnel -d ${toString tunnel.port} "${tunnel.remoteHost}" ${optionalString (tunnel.remotePort != null) (toString tunnel.remotePort)}
          '';
          Restart = "always";
          RuntimeMaxSec = mkIf (tunnel.restart != null) tunnel.restart;

          # Hardening options, sorted by occurrence in https://www.freedesktop.org/software/systemd/man/systemd.exec.html
          ProtectProc = "invisible";
          DynamicUser = true;
          CapabilityBoundingSet = [];
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateNetwork = false; # needs full network access
          PrivateUsers = false; # prevents binding to privileged ports
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];
          SystemCallArchitectures = "native";
          DevicePolicy = "closed";
        };
      }
    ) cfg.tunnels);

  };

  meta.maintainers = with maintainers; [ ymarkus ];
}
