{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) types;
  cfg = config.services.taskchampion-sync-server;
in
{
  options.services.taskchampion-sync-server = {
    enable = lib.mkEnableOption "TaskChampion Sync Server for Taskwarrior 3";
    package = lib.mkPackageOption pkgs "taskchampion-sync-server" { };
    user = lib.mkOption {
      description = "Unix User to run the server under";
      type = types.str;
      default = "taskchampion";
    };
    group = lib.mkOption {
      description = "Unix Group to run the server under";
      type = types.str;
      default = "taskchampion";
    };
    port = lib.mkOption {
      description = "Port on which to serve";
      type = types.port;
      default = 10222;
    };
    openFirewall = lib.mkEnableOption "Open firewall port for taskchampion-sync-server";
    dataDir = lib.mkOption {
      description = "Directory in which to store data";
      type = types.path;
      default = "/var/lib/taskchampion-sync-server";
    };
    snapshot = {
      versions = lib.mkOption {
        description = "Target number of versions between snapshots";
        type = types.ints.positive;
        default = 100;
      };
      days = lib.mkOption {
        description = "Target number of days between snapshots";
        type = types.ints.positive;
        default = 14;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
    };
    users.groups.${cfg.group} = { };
    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.openFirewall) [ cfg.port ];
    systemd.tmpfiles.settings = {
      "10-taskchampion-sync-server" = {
        "${cfg.dataDir}" = {
          d = {
            inherit (cfg) group user;
            mode = "0750";
          };
        };
      };
    };

    systemd.services.taskchampion-sync-server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = false;
        ExecStart = ''
          ${lib.getExe cfg.package} \
            --port ${builtins.toString cfg.port} \
            --data-dir ${cfg.dataDir} \
            --snapshot-versions ${builtins.toString cfg.snapshot.versions} \
            --snapshot-days ${builtins.toString cfg.snapshot.days}
        '';
      };
    };
  };
}
