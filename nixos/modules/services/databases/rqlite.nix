{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.rqlite;

  rqlite = cfg.package;

  runDir = "/run/rqlite";
in
{
  options = {
    services.rqlite = {
      enable = mkEnableOption "The Rqlite server";

      package = mkOption {
        default = pkgs.rqlite;
        defaultText = literalExpression "pkgs.rqlite";
        type = types.package;
        example = literalExpression "pkgs.rqlite";
        description = ''
          Which Rqlite package to be installed: <code>pkgs.rqlite</code>
        '';
      };

      httpPort = mkOption {
        default = 4001;
        type = types.port;
        description = ''
          HTTP port Rqlite uses.
        '';
      };

      raftPort = mkOption {
        default = 4002;
        type = types.port;
        description = ''
          Raft port Rqlite uses.
        '';
      };

      user = mkOption {
        default = "rqlite";
        type = types.str;
        description = ''
          User account under which rqlite runs.
        '';
      };

      group = mkOption {
        default = "rqlite";
        type = types.str;
        description = ''
          Group account under which rqlite runs.
        '';
      };

      stateDirectory = mkOption {
        default = "rqlite";
        type = types.str;
        description = ''
          SystemD's State Directories containing the databases
        '';
      };

      # TODO: In the future we could add "services.rqlite.clusters.<id>.join".
    };
  };

  config = mkIf config.services.rqlite.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.tmpfiles.rules = [
      "d '${runDir}' 0770 ${cfg.user} ${cfg.group}"
    ];
    systemd.services.rqlite =
      {
        description = "Rqlite server";

        wantedBy = [ "multi-user.target" ];

        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          LogsDirectory = "rqlite";
          LogsDirectoryMode = "0770";
          ExecStart = "${rqlite}/bin/rqlited -http-addr 0.0.0.0:${cfg.httpPort} -raft-addr 0.0.0.0:${cfg.raftPort} $STATE_DIRECTOR";
          Restart = always;
          # Security
          NoNewPrivileges = true;
          ProtectSystem = strict;
          ProtectHome = yes;
          StateDirectory = rqlite;
          StateDirectoryMode = 0770;
          ConfigurationDirectory = rqlite;
          ConfigurationDirectoryMode = 0770;
          PrivateTmp = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
        };
      };

    users.users = optionalAttrs (cfg.user == "rqlite") {
      rqlite = {
        description = "Rqlite server user";
        group = cfg.group;
        uid = config.ids.uids.rqlite;
      };
    };

    users.groups = optionalAttrs (cfg.group == "rqlite") {
      rqlite.gid = config.ids.gids.rqlite;
    };
  };
}
