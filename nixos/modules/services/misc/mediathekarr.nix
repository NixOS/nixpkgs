{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.mediathekarr;

  serviceEnvironment = {
    DOWNLOAD_COMPLETE_PATH = cfg.completePath;
    DOWNLOAD_INCOMPLETE_PATH = cfg.incompletePath;
    CATEGORIES = lib.concatStringsSep "," cfg.categories;
    CONFIG_PATH = cfg.configPath;
  };

  commonHardening = {
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectHostname = true;
    ProtectClock = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    DevicePolicy = "closed";
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictNamespaces = true;
    SystemCallArchitectures = "native";
    NoNewPrivileges = true;
    RestrictSUIDSGID = true;
    RemoveIPC = true;
    CapabilityBoundingSet = "";
    SystemCallFilter = [ "@system-service" ];

    PrivateNetwork = false;
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
    ];

    # Required for Dotnet (explicitly disabled for documentation here)
    MemoryDenyWriteExecute = false;
  };
in
{
  options.services.mediathekarr = {
    enable = lib.mkEnableOption "mediathekarr service";

    package = lib.mkPackageOption pkgs "mediathekarr" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "mediathekarr";
      description = "User account under which mediathekarr runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "mediathekarr";
      description = "Group under which mediathekarr runs.";
    };

    categories = lib.mkOption {
      type = with lib.types; listOf str;
      default = [
        "tv"
        "movies"
        "sonarr-blackhole"
        "radarr-blackhole"
      ];
      description = "Download categories.";
    };

    configPath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/mediathekarr";
      description = "Path to configuration directory.";
    };

    completePath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/mediathekarr/complete";
      description = "Path for completed downloads.";
    };

    incompletePath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/mediathekarr/incomplete";
      description = "Path for downloads in progress.";
    };

    downloaderListenAddress = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:5007";
      description = "Downloader listen address.";
    };

    serverListenAddress = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:5008";
      description = "Server listen address.";
    };
  };

  config = lib.mkIf cfg.enable {

    users.users = lib.mkIf (cfg.user == "mediathekarr") {
      mediathekarr = {
        isSystemUser = true;
        description = "mediathekarr user";
        home = cfg.configPath;
        group = cfg.group;
      };
    };

    users.groups = lib.mkIf (cfg.group == "mediathekarr") {
      ${cfg.group} = { };
    };

    systemd.targets.mediathekarr = {
      description = "Mediathekarr target";
      after = [
        "network.target"
        "network-online.target"
        "nss-lookup.target"
      ];
      wants = [
        "network.target"
        "network-online.target"
        "nss-lookup.target"
      ];
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.mediathekarr = {
      description = "Mediathekarr server";

      environment = serviceEnvironment // {
        ASPNETCORE_URLS = cfg.serverListenAddress;
      };

      after = [
        "network-online.target"
      ];
      wants = [
        "network-online.target"
      ];

      wantedBy = [ "mediathekarr.target" ];

      confinement = {
        enable = true;
        mode = "full-apivfs";
      };

      serviceConfig = commonHardening // {
        Type = "exec";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "mediathekarr";
        ExecStart = "${lib.getExe' cfg.package "MediathekArrServer"}";
        WorkingDirectory = "${lib.getLib cfg.package}/lib/mediathekarr-server";
        Restart = "on-failure";

        # Strictly speaking not necessary if they are the default paths, but include them anyway for simplicity.
        BindPaths = [
          cfg.completePath
          cfg.incompletePath
        ];

        BindReadOnlyPaths = [
          "${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt"
          "/etc/resolv.conf"
        ];
      };
    };

    systemd.services.mediathekarr-downloader = {
      description = "Mediathekarr downloader";

      environment = serviceEnvironment // {
        ASPNETCORE_URLS = cfg.downloaderListenAddress;
      };

      # nss-lookup.target: Required because downloader process tries to resolve API hostname during startup.
      after = [
        "network-online.target"
        "nss-lookup.target"
      ];
      wants = [
        "network-online.target"
        "nss-lookup.target"
      ];

      wantedBy = [ "mediathekarr.target" ];

      confinement = {
        enable = true;
        mode = "full-apivfs";
      };

      serviceConfig = commonHardening // {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "mediathekarr";
        ExecStart = "${lib.getExe' cfg.package "MediathekArrDownloader"}";
        WorkingDirectory = "${lib.getLib cfg.package}/lib/mediathekarr-downloader";
        Restart = "on-failure";

        # Strictly speaking not necessary if they are the default paths, but include them anyway for simplicity.
        BindPaths = [
          cfg.completePath
          cfg.incompletePath
        ];

        BindReadOnlyPaths = [
          "${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt"
          "/etc/resolv.conf"
        ];
      };
    };

    systemd.tmpfiles.settings."51-mediathekarr" = {
      "${cfg.completePath}"."d" = lib.mkIf (cfg.completePath == "/var/lib/mediathekarr/complete") {
        inherit (cfg) user group;
        mode = "0755";
      };
      "${cfg.incompletePath}"."d" = lib.mkIf (cfg.incompletePath == "/var/lib/mediathekarr/incomplete") {
        inherit (cfg) user group;
        mode = "0755";
      };
    };
  };
}
