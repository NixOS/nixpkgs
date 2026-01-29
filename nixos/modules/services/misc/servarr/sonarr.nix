{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.sonarr;
  servarr = import ./settings-options.nix { inherit lib pkgs; };
in
{
  options = {
    services.sonarr = {
      enable = lib.mkEnableOption "Sonarr";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/sonarr/.config/NzbDrone";
        description = "The directory where Sonarr stores its data files.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the Sonarr web interface
        '';
      };

      environmentFiles = servarr.mkServarrEnvironmentFiles "sonarr";

      settings = servarr.mkServarrSettingsOptions "sonarr" 8989;

      user = lib.mkOption {
        type = lib.types.str;
        default = "sonarr";
        description = "User account under which Sonaar runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "sonarr";
        description = "Group under which Sonaar runs.";
      };

      package = lib.mkPackageOption pkgs "sonarr" { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.sonarr = {
      description = "Sonarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = servarr.mkServarrSettingsEnvVars "SONARR" cfg.settings;
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "-nobrowser"
          "-data=${cfg.dataDir}"
        ];
        Restart = "on-failure";

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        UMask = "0022";
        ProtectHostname = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        LockPersonality = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@debug"
          "~@mount"
        ];
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.server.port ];
    };

    users.users = lib.mkIf (cfg.user == "sonarr") {
      sonarr = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.sonarr;
      };
    };

    users.groups = lib.mkIf (cfg.group == "sonarr") {
      sonarr.gid = config.ids.gids.sonarr;
    };
  };
}
