{ config, pkgs, lib, ... }:
let
  cfg = config.services.jellyseerr;
in
{
  meta.maintainers = [ lib.maintainers.camillemndn ];

  options.services.jellyseerr = {
    enable = lib.mkEnableOption ''Jellyseerr, a requests manager for Jellyfin'';
    package = lib.mkPackageOption pkgs "jellyseerr" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''Open port in the firewall for the Jellyseerr web interface.'';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = ''The port which the Jellyseerr web UI should listen to.'';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.jellyseerr = {
      description = "Jellyseerr, a requests manager for Jellyfin";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.PORT = toString cfg.port;
      serviceConfig = {
        Type = "exec";
        StateDirectory = "jellyseerr";
        WorkingDirectory = "${cfg.package}/libexec/jellyseerr/deps/jellyseerr";
        DynamicUser = true;
        ExecStart = lib.getExe cfg.package;
        BindPaths = [ "/var/lib/jellyseerr/:${cfg.package}/libexec/jellyseerr/deps/jellyseerr/config/" ];
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

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
