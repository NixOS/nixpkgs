{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.tautulli;
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "plexpy" ] [ "services" "tautulli" ])
  ];

  options = {
    services.tautulli = {
      enable = mkEnableOption "Tautulli Plex Monitor";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/plexpy";
        description = "The directory where Tautulli stores its data files.";
      };

      configFile = mkOption {
        type = types.str;
        default = "/var/lib/plexpy/config.ini";
        description = "The location of Tautulli's config file.";
      };

      port = mkOption {
        type = types.port;
        default = 8181;
        description = "TCP port where Tautulli listens.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for Tautulli.";
      };

      user = mkOption {
        type = types.str;
        default = "plexpy";
        description = "User account under which Tautulli runs.";
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = "Group under which Tautulli runs.";
      };

      package = mkPackageOption pkgs "tautulli" { };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.tautulli = {
      description = "Tautulli Plex Monitor";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        GuessMainPID = "false";
        ExecStart = "${cfg.package}/bin/tautulli --datadir ${cfg.dataDir} --config ${cfg.configFile} --port ${toString cfg.port} --pidfile ${cfg.dataDir}/tautulli.pid --nolaunch";
        Restart = "on-failure";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    users.users = mkIf (cfg.user == "plexpy") {
      plexpy = {
        group = cfg.group;
        uid = config.ids.uids.plexpy;
      };
    };
  };
}
