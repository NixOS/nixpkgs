{ config, lib, pkgs, ... }:
let

  cfg = config.services.surrealdb;
in {

  options = {
    services.surrealdb = {
      enable = lib.mkEnableOption "SurrealDB, a scalable, distributed, collaborative, document-graph database, for the realtime web";

      package = lib.mkPackageOption pkgs "surrealdb" { };

      dbPath = lib.mkOption {
        type = lib.types.str;
        description = ''
          The path that surrealdb will write data to. Use null for in-memory.
          Can be one of "memory", "file://:path", "tikv://:addr".
        '';
        default = "file:///var/lib/surrealdb/";
        example = "memory";
      };

      host = lib.mkOption {
        type = lib.types.str;
        description = ''
          The host that surrealdb will connect to.
        '';
        default = "127.0.0.1";
        example = "127.0.0.1";
      };

      port = lib.mkOption {
        type = lib.types.port;
        description = ''
          The port that surrealdb will connect to.
        '';
        default = 8000;
        example = 8000;
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = [ "--allow-all" "--auth" "--user root" "--pass root" ];
        description = ''
          Specify a list of additional command line flags,
          which get escaped and are then passed to surrealdb.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    # Used to connect to the running service
    environment.systemPackages = [ cfg.package ] ;

    systemd.services.surrealdb = {
      description = "A scalable, distributed, collaborative, document-graph database, for the realtime web";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/surreal start --bind ${cfg.host}:${toString cfg.port} ${lib.escapeShellArgs cfg.extraFlags} -- ${cfg.dbPath}";
        DynamicUser = true;
        Restart = "on-failure";
        StateDirectory = "surrealdb";
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectProc = "noaccess";
        ProcSubset = "pid";
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        RemoveIPC = true;
        SystemCallFilter = [ "@system-service" "~@privileged" ];
      };
    };
  };
}
