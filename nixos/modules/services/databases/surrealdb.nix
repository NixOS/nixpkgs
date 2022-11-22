{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.services.surrealdb;
in {

  options = {
    services.surrealdb = {
      enable = mkEnableOption (lib.mdDoc "A scalable, distributed, collaborative, document-graph database, for the realtime web ");

      dbPath = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The path that surrealdb will write data to. Use null for in-memory.
          Can be one of "memory", "file://:path", "tikv://:addr".
        '';
        default = "file:///var/lib/surrealdb/";
        example = "memory";
      };

      host = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The host that surrealdb will connect to.
        '';
        default = "127.0.0.1";
        example = "127.0.0.1";
      };

      port = mkOption {
        type = types.port;
        description = lib.mdDoc ''
          The port that surrealdb will connect to.
        '';
        default = 8000;
        example = 8000;
      };
    };
  };

  config = mkIf cfg.enable {

    # Used to connect to the running service
    environment.systemPackages = [ pkgs.surrealdb ] ;

    systemd.services.surrealdb = {
      description = "A scalable, distributed, collaborative, document-graph database, for the realtime web ";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.surrealdb}/bin/surreal start --bind ${cfg.host}:${toString cfg.port} ${optionalString (cfg.dbPath != null) "-- ${cfg.dbPath}"}";
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
