{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.plexpy;
in
{
  options = {
    services.plexpy = {
      enable = mkEnableOption "PlexPy Plex Monitor";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/plexpy";
        description = "The directory where PlexPy stores its data files.";
      };

      configFile = mkOption {
        type = types.str;
        default = "/var/lib/plexpy/config.ini";
        description = "The location of PlexPy's config file.";
      };

      port = mkOption {
        type = types.int;
        default = 8181;
        description = "TCP port where PlexPy listens.";
      };

      user = mkOption {
        type = types.str;
        default = "plexpy";
        description = "User account under which PlexPy runs.";
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = "Group under which PlexPy runs.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.plexpy;
        defaultText = "pkgs.plexpy";
        description = ''
          The PlexPy package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.plexpy = {
      description = "PlexPy Plex Monitor";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        GuessMainPID = "false";
        ExecStart = "${cfg.package}/bin/plexpy --datadir ${cfg.dataDir} --config ${cfg.configFile} --port ${toString cfg.port} --pidfile ${cfg.dataDir}/plexpy.pid --nolaunch";
        Restart = "on-failure";
      };
    };

    users.users = mkIf (cfg.user == "plexpy") {
      plexpy = { group = cfg.group; uid = config.ids.uids.plexpy; };
    };
  };
}
