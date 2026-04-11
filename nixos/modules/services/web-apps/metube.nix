{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.metube;
in
{
  meta.maintainers = with lib.maintainers; [ hunterwilkins2 ];

  options = {
    services.metube = {
      enable = lib.mkEnableOption "MeTube, self-hosted video downloader";

      package = lib.mkPackageOption pkgs "metube" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "metube";
        description = "User which will own the downloaded files";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "metube";
        description = "Group with will own the downloaded files";
      };

      openPorts = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open the web ui port in the firewall";
      };

      settings = lib.mkOption {
        type = lib.types.submodule { freeformType = with lib.types; attrsOf str; };
        default = { };
        example = {
          PORT = "8081";
          MAX_CONCURRENT_DOWNLOADS = 5;
          DOWNLOAD_DIR = "/home/<user>/Downloads";
          OUTPUT_TEMPLATE = "%(title)s.%(ext)s";
          DEFAULT_THEME = "dark";
        };
        description = ''
          Additional configuration for MeTube, see
          <https://github.com/alexta69/metube/tree/master?tab=readme-ov-file#%EF%B8%8F-configuration-via-environment-variables>
          for supported values. `DOWNLOAD_DIR` is required.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.DOWNLOAD_DIR != "";
        message = "services.metube.settings.DOWNLOAD_DIR must be set";
      }
    ];

    services.metube.settings = {
      PORT = lib.mkDefault "8081";
      STATE_DIR = "/var/lib/metube";
      TEMP_DIR = "/tmp";
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.settings.DOWNLOAD_DIR} 0755 ${cfg.user} ${cfg.group} - -"
    ];

    users.users = lib.optionalAttrs (cfg.user == "metube") {
      metube = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "metube") {
      metube = { };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openPorts [ (lib.toInt cfg.settings.PORT) ];

    systemd.services.metube = {
      description = "MeTube";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.settings;
      serviceConfig = {
        Type = "simple";
        StateDirectory = "metube";
        StateDirectoryMode = "750";
        ReadWritePaths = [ cfg.settings.DOWNLOAD_DIR ];
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/metube";
        Restart = "on-failure";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = false;
        MountAPIVFS = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = 022;
      };
    };
  };
}
