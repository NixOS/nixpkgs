{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.services.surrealdb;
in {

  options = {
    services.surrealdb = {
      enable = mkEnableOption (lib.mdDoc "A scalable, distributed, collaborative, document-graph database, for the realtime web ");

      package = mkOption {
        default = pkgs.surrealdb;
        defaultText = literalExpression "pkgs.surrealdb";
        type = types.package;
        description = lib.mdDoc ''
          Which surrealdb derivation to use.
        '';
      };

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

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--allow-all" "--auth" "--user root" "--pass root" ];
        description = lib.mdDoc ''
          Specify a list of additional command line flags,
          which get escaped and are then passed to surrealdb.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    # Used to connect to the running service
    environment.systemPackages = [ cfg.package ] ;

    systemd.services.surrealdb = {
      description = "A scalable, distributed, collaborative, document-graph database, for the realtime web ";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/surreal start --bind ${cfg.host}:${toString cfg.port} ${escapeShellArgs cfg.extraFlags} -- ${cfg.dbPath}";
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
