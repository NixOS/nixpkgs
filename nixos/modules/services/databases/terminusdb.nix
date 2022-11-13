{ config, lib, pkgs, ... }:

with lib;

let
  format = pkgs.formats.json { };
  cfg = config.services.terminusdb;
in
{
  options = {
    services.terminusdb = {
      enable = mkEnableOption (lib.mdDoc "the terminusdb server");

      package = mkOption {
        default = pkgs.terminusdb;
        defaultText = literalExpression "pkgs.terminusdb";
        description = lib.mdDoc "terminusdb derivation to use.";
        type = types.package;
      };

      port = mkOption {
        default = 6363;
        defaultText = literalExpression "6363";
        description = lib.mdDoc "port for terminusdb server.";
        type = types.port;
      };

      address = mkOption {
        default = "127.0.0.1";
        defaultText = literalExpression "\"127.0.0.1\"";
        description = lib.mdDoc "address for server to listen on";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.terminusdb = {
      description = "Terminusdb is an open-source, document-graph database";
      documentation = [ "https://terminusdb.com/docs" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        #https://terminusdb.com/docs/guides/interface-guides/cli#environment
        TERMINUSDB_SERVER_NAME = "${cfg.address}";
        TERMINUSDB_SERVER_PORT = "${toString cfg.port}";
      };
      serviceConfig = {
        ExecStartPre = "/bin/sh -c 'test -d storage || ${cfg.package}/bin/terminusdb store init'";
        ExecStart = "${cfg.package}/bin/terminusdb serve";
        StateDirectory = "terminusdb";
        WorkingDirectory = "/var/lib/terminusdb";
        DynamicUser = "true";

        #hardening
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictNamespaces = true;
        NoNewPrivileges = true;
        ProtectControlGroups = true;
        SystemCallArchitectures = "native";
        PrivateTmp = true;
        LockPersonality = true;
        ProtectSystem = true;
        PrivateUsers = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        ProtectHome = true;
        ProtectKernelLogs = true;
        PrivateDevices = true;
        ProtectClock = true;
        DevicePolicy = "closed";
        ProcSubset = "pid";

        LimitNOFILE = 65536;
        KillMode = "control-group";
        Restart = "on-failure";
      };
    };
  };
}
