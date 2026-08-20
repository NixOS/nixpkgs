{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.chaptarr;
  servarr = import ./settings-options.nix { inherit lib pkgs; };
in
{
  meta.maintainers = [ lib.maintainers.lnk3 ];

  options.services.chaptarr = {
    enable = lib.mkEnableOption "Chaptarr";

    package = lib.mkPackageOption pkgs "chaptarr" { };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.m4b-tool pkgs.ffmpeg ]";
      description = "Extra packages available on Chaptarr systemd service's PATH for optional integrations .";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/chaptarr";
      description = "The directory where Chaptarr stores its data files.";
    };

    extraReadWritePaths = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression ''
        [
          "/data/audiobooks"
          "/data/ebooks"
          "/data/downloads"
          "''${services.qbittorrent.profileDir}"
          "''${services.transmission.settings.download-dir}"
        ]
      '';
      description = ''
        Additional paths Chaptarr is allowed to write to.
        Add your media library folders.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the firewall for the Chaptarr web interface.";
    };

    settings = servarr.mkServarrSettingsOptions "chaptarr" 8789;

    environmentFiles = servarr.mkServarrEnvironmentFiles "chaptarr";

    user = lib.mkOption {
      type = lib.types.str;
      default = "chaptarr";
      description = "User account under which Chaptarr runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "chaptarr";
      description = "Group under which Chaptarr runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-chaptarr".${cfg.dataDir}.d = {
      user = cfg.user;
      group = cfg.group;
      mode = "0700";
    };

    systemd.services.chaptarr = {
      description = "Chaptarr";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
      ]
      ++ lib.optional (lib.attrByPath [ "postgres" "host" ] "" cfg.settings != "") "postgresql.service";
      wants = lib.optional (
        lib.attrByPath [ "postgres" "host" ] "" cfg.settings != ""
      ) "postgresql.service";
      environment = servarr.mkServarrSettingsEnvVars "chaptarr" cfg.settings;
      path = cfg.extraPackages;
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${lib.getExe cfg.package} -nobrowser -data='${cfg.dataDir}'";
        EnvironmentFile = cfg.environmentFiles;
        Restart = "on-failure";
        SyslogIdentifier = "chaptarr";
        KillSignal = "SIGINT";
        SuccessExitStatus = "0 156";
        WorkingDirectory = cfg.dataDir;

        # Hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ReadWritePaths = [ cfg.dataDir ] ++ cfg.extraReadWritePaths;
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
          "AF_NETLINK" # Required. Gives runtime error when not granted.
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
          "@chown"
        ];
      };

      unitConfig.RequiresMountsFor = [ cfg.dataDir ];
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.server.port ];
    };

    users.users = lib.mkIf (cfg.user == "chaptarr") {
      chaptarr = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };
    };

    users.groups = lib.mkIf (cfg.group == "chaptarr") {
      chaptarr = { };
    };
  };
}
