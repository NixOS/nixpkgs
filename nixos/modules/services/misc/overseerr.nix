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

    openFirewall = lib.mkEnableOption "opening a port in the firewall for the Overseerr web interface";

    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = ''The port which the Overseerr web UI should listen to.'';
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/overseerr";
      description = "The directory where Overseerr stores its data files.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "overseerr";
      description = "User account under which Overseerr runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "overseerr";
      description = "Group under which Overseerr runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-overseerr".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.overseerr = {
      description = "Request management and media discovery tool for the Plex ecosystem";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        CONFIG_DIRECTORY = cfg.dataDir;
        PORT = toString cfg.port;
      };
      serviceConfig = {
        Type = "exec";
        WorkingDirectory = "${cfg.package}/libexec/overseerr/deps/overseerr";
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
        ReadWritePaths = [ cfg.dataDir ];
        User = cfg.user;
        Group = cfg.group;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    users.users = lib.mkIf (cfg.user == "overseerr") {
      overseerr = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.overseerr;
      };
    };

    users.groups = lib.mkIf (cfg.group == "overseerr") {
      overseerr.gid = config.ids.gids.overseerr;
    };
  };
}
