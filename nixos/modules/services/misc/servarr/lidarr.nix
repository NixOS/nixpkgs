{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.lidarr;
  servarr = import ./settings-options.nix { inherit lib pkgs; };
in
{
  options = {
    services.lidarr = {
      enable = lib.mkEnableOption "Lidarr, a Usenet/BitTorrent music downloader";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/lidarr/.config/Lidarr";
        description = "The directory where Lidarr stores its data files.";
      };

      package = lib.mkPackageOption pkgs "lidarr" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for Lidarr
        '';
      };

      settings = servarr.mkServarrSettingsOptions "lidarr" 8686;

      environmentFiles = servarr.mkServarrEnvironmentFiles "lidarr";

      user = lib.mkOption {
        type = lib.types.str;
        default = "lidarr";
        description = ''
          User account under which Lidarr runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "lidarr";
        description = ''
          Group under which Lidarr runs.
        '';
      };

      libraryPaths = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        example = [
          "/media/music"
          "/media/misc"
        ];
        description = ''
          Absolute paths to bind-mount as mutable to the service.
          These paths specified will be created and owned by the lidarr service {option}`user` and {option}`group`.
          These paths must still be selected manually at initial start-up for library usage.

          If additional paths are required for the service that are not owned by the lidarr user,
          add them to {option}`config.systemd.services.lidarr.serviceConfig.BindReadOnlyPaths`
          or {option}`config.systemd.services.lidarr.serviceConfig.BindPaths`.

          Lidarr is ran inside a {manpage}`pivot_root(2)`, so any paths not bind-mounted will not be visible
          to Lidarr.
        '';
      };

      libraryPermissions = lib.mkOption {
        type = lib.types.str;
        default = "750";
        example = "2755";
        description = ''
          Permissions to create the {option}`libraryPaths` with in octal format.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-lidarr" = {
      ${cfg.dataDir}.d = {
        inherit (cfg) user group;
        mode = "0700";
      };
    }
    // lib.genAttrs cfg.libraryPath (_: {
      d = {
        inherit (cfg) user group;
        mode = cfg.libraryPermissions;
      };
    });

    systemd.services.lidarr = {
      description = "Lidarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = servarr.mkServarrSettingsEnvVars "LIDARR" cfg.settings;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = "${cfg.package}/bin/Lidarr -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";

        # Hardening
        RuntimeDirectory = "lidarr";
        RootDirectory = "/run/lidarr"; # pivot_root to /run/lidarr
        StateDirectory = "lidarr";
        WorkingDirectory = cfg.dataDir;
        ReadWritePaths = "";
        BindPaths = [
          cfg.dataDir
        ]
        ++ cfg.libraryPaths;

        # Paths for TLS and DNS
        BindReadOnlyPaths = [
          builtins.storeDir
          "/etc"
        ]
        ++ lib.optionals config.services.resolved.enable [
          "/run/systemd/resolve/stub-resolv.conf"
          "/run/systemd/resolve/resolv.conf"
        ];

        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        SystemCallFilter = [
          "@system-service"
          "@chown"
          "chmod"
          "fchmod"
          "fchmodat"
          "fchmodat2"
          "~@privileged"
        ];
        UMask = "0007";

        SystemCallArchitectures = "native";
        ProtectSystem = "strict"; # Mount all as r/o
        ProtectProc = "invisible";

        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivatePIDs = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectControlGroup = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;

        # Networking
        SocketBindDeny = "any";
        SocketBindAllow = "tcp:${toString cfg.settings.server.port}"; # Only allow binding the specified port
        SystemCallErrorNumber = "EPERM";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.server.port ];
    };

    users.users = lib.mkIf (cfg.user == "lidarr") {
      lidarr = {
        group = cfg.group;
        home = "/var/lib/lidarr";
        uid = config.ids.uids.lidarr;
      };
    };

    users.groups = lib.mkIf (cfg.group == "lidarr") {
      lidarr = {
        gid = config.ids.gids.lidarr;
      };
    };
  };
}
