{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) types;
  cfg = config.services.taskchampion-sync-server;
  defaultUser = "taskchampion";
  defaultGroup = "taskchampion";
  defaultDir = "/var/lib/taskchampion-sync-server";
in
{
  options.services.taskchampion-sync-server = {
    enable = lib.mkEnableOption "TaskChampion Sync Server for Taskwarrior 3";
    package = lib.mkPackageOption pkgs "taskchampion-sync-server" { };
    user = lib.mkOption {
      description = "Unix User to run the server under";
      type = types.str;
      default = defaultUser;
    };
    group = lib.mkOption {
      description = "Unix Group to run the server under";
      type = types.str;
      default = defaultGroup;
    };
    host = lib.mkOption {
      description = "Host address on which to serve";
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
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
      default = defaultDir;
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
    allowClientIds = lib.mkOption {
      description = "Client IDs to allow (can be repeated; if not specified, all clients are allowed)";
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = lib.mkIf (cfg.user == defaultUser) {
      isSystemUser = true;
      inherit (cfg) group;
    };
    users.groups.${cfg.group} = lib.mkIf (cfg.group == defaultGroup) { };
    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.openFirewall) [ cfg.port ];

    systemd.services.taskchampion-sync-server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        # If we enable DynamicUser, users need to move
        # /var/lib/taskchampion-sync-server to
        # /var/lib/private/taskchampion-sync-server manually, which is a
        # breakage. So we keep the old behavior and we'll do the migration in
        # another PR.
        DynamicUser = false;
        StateDirectory = lib.mkIf (cfg.dataDir == defaultDir) "taskchampion-sync-server";
        ExecStart = ''
          ${lib.getExe cfg.package} \
            --listen "${cfg.host}:${toString cfg.port}" \
            --data-dir ${cfg.dataDir} \
            --snapshot-versions ${toString cfg.snapshot.versions} \
            --snapshot-days ${toString cfg.snapshot.days} \
            ${lib.concatMapStringsSep " " (id: "--allow-client-id ${id}") cfg.allowClientIds}
        '';
      };
    };
  };
}
