{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.restic.server;
in
{
  meta.maintainers = [ maintainers.bachp ];

  options.services.restic.server = {
    enable = mkEnableOption "Restic REST Server";

    listenAddress = mkOption {
      default = ":8000";
      example = "127.0.0.1:8080";
      type = types.str;
      description = "Listen on a specific IP address and port.";
    };

    dataDir = mkOption {
      default = "/var/lib/restic";
      type = types.path;
      description = "The directory for storing the restic repository.";
    };

    appendOnly = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Enable append only mode.
        This mode allows creation of new backups but prevents deletion and modification of existing backups.
        This can be useful when backing up systems that have a potential of being hacked.
      '';
    };

    privateRepos = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Enable private repos.
        Grants access only when a subdirectory with the same name as the user is specified in the repository URL.
      '';
    };

    prometheus = mkOption {
      default = false;
      type = types.bool;
      description = "Enable Prometheus metrics at /metrics.";
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Extra commandline options to pass to Restic REST server.
      '';
    };

    package = mkOption {
      default = pkgs.restic-rest-server;
      defaultText = "pkgs.restic-rest-server";
      type = types.package;
      description = "Restic REST server package to use.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.restic-rest-server = {
      description = "Restic REST Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/rest-server \
          --listen ${cfg.listenAddress} \
          --path ${cfg.dataDir} \
          ${optionalString cfg.appendOnly "--append-only"} \
          ${optionalString cfg.privateRepos "--private-repos"} \
          ${optionalString cfg.prometheus "--prometheus"} \
          ${escapeShellArgs cfg.extraFlags} \
        '';
        Type = "simple";
        User = "restic";
        Group = "restic";

        # Security hardening
        ReadWritePaths = [ cfg.dataDir ];
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        PrivateDevices = true;
      };
    };

    users.users.restic = {
      group = "restic";
      home = cfg.dataDir;
      createHome = true;
      uid = config.ids.uids.restic;
    };

    users.groups.restic.gid = config.ids.uids.restic;
  };
}
