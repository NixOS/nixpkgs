{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.overseerr;
in
{
  meta.maintainers = [ ];

  options.services.overseerr = {
    enable = mkEnableOption (mdDoc ''Overseerr, a requests manager for Plex'');

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''Open port in the firewall for the Overseerr web interface.'';
    };

    port = mkOption {
      type = types.port;
      default = 5055;
      description = mdDoc ''The port which the Overseerr web UI should listen to.'';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.overseerr = {
      description = "Overseerr, a requests manager for Plex";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.PORT = toString cfg.port;
      serviceConfig = {
        Type = "exec";
        StateDirectory = "overseerr";
        WorkingDirectory = "${pkgs.overseerr}/libexec/overseerr/deps/overseerr";
        DynamicUser = true;
        ExecStart = "${pkgs.overseerr}/bin/overseerr";
        BindPaths = [ "/var/lib/overseerr/:${pkgs.overseerr}/libexec/overseerr/deps/overseerr/config/" ];
        Restart = "on-failure";
        ProtectHome = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
