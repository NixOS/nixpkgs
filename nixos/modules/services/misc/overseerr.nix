{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.overseerr;
in
{
  meta.maintainers = [ lib.maintainers.jf-uu ];

  options.services.overseerr = {
    enable = lib.mkEnableOption "Overseerr, a request management and media discovery tool for the Plex ecosystem";

    package = lib.mkPackageOption pkgs "overseerr" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open a port in the firewall for the Overseerr web interface.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = "The port which the Overseerr web UI should listen on.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.overseerr = {
      description = "Request management and media discovery tool for the Plex ecosystem";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        CONFIG_DIRECTORY = "/var/lib/overseerr";
        PORT = toString cfg.port;
      };
      serviceConfig = {
        Type = "exec";
        ExecStart = lib.getExe cfg.package;
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
        StateDirectory = "overseerr";
        StateDirectoryMode = "0700";
        DynamicUser = true;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
