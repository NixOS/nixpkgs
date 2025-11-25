{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.restic.server;
in
{
  meta.maintainers = [ lib.maintainers.bachp ];

  options.services.restic.server = {
    enable = lib.mkEnableOption "Restic REST Server";

    listenAddress = lib.mkOption {
      default = "8000";
      example = "127.0.0.1:8080";
      type = lib.types.str;
      description = "Listen on a specific IP address and port or unix socket.";
    };

    dataDir = lib.mkOption {
      default = "/var/lib/restic";
      type = lib.types.path;
      description = "The directory for storing the restic repository.";
    };

    appendOnly = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Enable append only mode.
        This mode allows creation of new backups but prevents deletion and modification of existing backups.
        This can be useful when backing up systems that have a potential of being hacked.
      '';
    };

    htpasswd-file = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "The path to the servers .htpasswd file. Defaults to `\${dataDir}/.htpasswd`.";
    };

    privateRepos = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Enable private repos.
        Grants access only when a subdirectory with the same name as the user is specified in the repository URL.
      '';
    };

    prometheus = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Prometheus metrics at /metrics.";
    };

    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra commandline options to pass to Restic REST server.
      '';
    };

    package = lib.mkPackageOption pkgs "restic-rest-server" { };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.substring 0 1 cfg.listenAddress != ":";
        message = "The restic-rest-server now uses systemd socket activation, which expects only the Port number: services.restic.server.listenAddress = \"${
          lib.substring 1 6 cfg.listenAddress
        }\";";
      }
    ];

    systemd.services.restic-rest-server = {
      description = "Restic REST Server";
      after = [
        "network.target"
        "restic-rest-server.socket"
      ];
      requires = [ "restic-rest-server.socket" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/rest-server \
          --path ${cfg.dataDir} \
          ${lib.optionalString (cfg.htpasswd-file != null) "--htpasswd-file ${cfg.htpasswd-file}"} \
          ${lib.optionalString cfg.appendOnly "--append-only"} \
          ${lib.optionalString cfg.privateRepos "--private-repos"} \
          ${lib.optionalString cfg.prometheus "--prometheus"} \
          ${lib.escapeShellArgs cfg.extraFlags} \
        '';
        Type = "simple";
        User = "restic";
        Group = "restic";

        # Security hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateNetwork = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        PrivateDevices = true;
        ReadWritePaths = [ cfg.dataDir ];
        ReadOnlyPaths = lib.optional (cfg.htpasswd-file != null) cfg.htpasswd-file;
        RemoveIPC = true;
        RestrictAddressFamilies = "none";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        UMask = 27;
      };
    };

    systemd.sockets.restic-rest-server = {
      listenStreams = [ cfg.listenAddress ];
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ReusePort = true;
      };
    };

    systemd.tmpfiles.rules = lib.mkIf cfg.privateRepos [
      "f ${cfg.dataDir}/.htpasswd 0700 restic restic -"
    ];

    users.users.restic = {
      group = "restic";
      home = cfg.dataDir;
      createHome = true;
      uid = config.ids.uids.restic;
    };

    users.groups.restic.gid = config.ids.uids.restic;
  };
}
