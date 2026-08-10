{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.aurral;
in
{
  options = {
    services.aurral = {
      enable = lib.mkEnableOption "Aurral is the Lidarr companion for self-hosted music discovery";

      package = lib.mkPackageOption pkgs "aurral" { };

      directories = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          Directories that Aurral needs access to. Other directories won't be visible by the app.
          Environment variable `DOWNLOAD_FOLDER` is added automatically.
          See BindPaths in {manpage}`systemd.exec(5)`.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3001;
        description = "Port number";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for Aurral.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "aurral";
        description = ''
          User account under which Aurral runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "aurral";
        description = ''
          Group under which Aurral runs.
        '';
      };

      environment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          DOWNLOAD_FOLDER = "/media/downloads";
          TRUST_PROXY = "true";
        };
        description = ''
          Environment variables passed to the service.
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Environment file as defined in {manpage}`systemd.exec(5)` passed to the service.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.aurral = {
      description = "Aurral";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.environment // {
        AURRAL_DATA_DIR = "/var/lib/aurral";
        PORT = toString cfg.port;
      };

      path = [ cfg.package ];

      serviceConfig = {
        Type = "simple";
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        StateDirectory = "aurral";
        WorkingDirectory = "/var/lib/aurral";
        ReadWritePaths = "";
        ProtectSystem = "strict";
        BindPaths = [
          "/var/lib/aurral"
        ]
        ++ (lib.map (x: "-" + x) cfg.directories)
        ++ lib.optional (cfg.environment ? DOWNLOAD_FOLDER) cfg.environment.DOWNLOAD_FOLDER;
        BindReadOnlyPaths = [
          builtins.storeDir
          "${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt"
          "-/etc/resolv.conf"
        ]
        ++ lib.optionals config.services.resolved.enable [
          "/run/systemd/resolve/stub-resolv.conf"
          "/run/systemd/resolve/resolv.conf"
        ];
        RestrictSUIDSGID = true;
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        SocketBindDeny = "any";
        SocketBindAllow = toString cfg.port;
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
        SystemCallArchitectures = "native";
        ProtectProc = "invisible";
        ProcSubset = "pid";
        LockPersonality = true;
        NoNewPrivileges = true;
        DevicePolicy = "closed";
        PrivateIPC = true;
        PrivatePIDs = true;
        ProtectClock = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectHostname = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        MemoryDenyWriteExecute = false;
      };

      confinement.enable = true;
    };

    systemd.tmpfiles.settings."10-aurral" = lib.mkIf (cfg.environment ? DOWNLOAD_FOLDER) {
      ${cfg.environment.DOWNLOAD_FOLDER}.d = {
        inherit (cfg) user group;
        mode = "0770";
      };
    };

    users.users = lib.mkIf (cfg.user == "aurral") {
      aurral = {
        isSystemUser = true;
        home = "/var/lib/aurral";
        group = cfg.group;
      };
    };

    users.groups = lib.mkIf (cfg.group == "aurral") {
      aurral = { };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
